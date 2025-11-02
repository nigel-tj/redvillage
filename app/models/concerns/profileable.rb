module Profileable
  extend ActiveSupport::Concern

  included do
    has_one :profile, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :profile, update_only: true
    
    # Ensure profile exists
    after_create :ensure_profile_exists
  end

  # Delegate profile methods to profile if it exists
  def bio
    profile&.bio
  end

  def bio=(value)
    build_profile unless profile
    profile.bio = value
  end

  def phone
    profile&.phone
  end

  def phone=(value)
    build_profile unless profile
    profile.phone = value
  end

  def profile_picture_url(version = nil)
    return nil unless profile
    if profile.profile_picture.present?
      profile.profile_picture_url(version) rescue nil
    elsif respond_to?(:profile_picture) && profile_picture.present?
      profile_picture_url(version) rescue nil
    else
      nil
    end
  end

  def cover_image_url(version = nil)
    return nil unless profile
    if profile.cover_image.present?
      profile.cover_image_url(version) rescue nil
    elsif respond_to?(:cover) && cover.present?
      cover_url(version) rescue nil
    else
      nil
    end
  end

  def website
    profile&.website
  end

  def social_links
    profile&.social_links || {}
  end

  def has_profile?
    profile.present?
  end

  def ensure_profile_exists
    create_profile unless profile.present?
  end

  def display_name
    name || email
  end

  def profile_complete?
    return false unless profile
    profile.bio.present? && profile.profile_picture.present?
  end

  # Role-specific profile helpers
  def profile_title
    case role
    when 'dj'
      "DJ Profile"
    when 'artist'
      "Artist Profile"
    when 'photographer'
      "Photographer Profile"
    when 'videographer'
      "Videographer Profile"
    when 'curator'
      "Curator Profile"
    when 'designer'
      "Designer Profile"
    when 'editor'
      "Editor Profile"
    else
      "Profile"
    end
  end
end

