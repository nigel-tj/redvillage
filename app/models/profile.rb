class Profile < ActiveRecord::Base
  belongs_to :user
  
  include ImageUploader::Attachment(:profile_picture) if defined?(ImageUploader)
  include ImageUploader::Attachment(:cover_image) if defined?(ImageUploader)
  
  validates :user_id, uniqueness: true
  
  # Social media URL validations
  validates :facebook_url, :twitter_url, :instagram_url, :linkedin_url, :youtube_url,
            :spotify_url, :soundcloud_url, :pinterest_url, :tiktok_url,
            format: { with: /\Ahttps?:\/\/.+\z/, message: "must be a valid URL" },
            allow_blank: true
  validates :website, format: { with: /\Ahttps?:\/\/.+\z/, message: "must be a valid URL" }, allow_blank: true
  
  def full_name
    user&.name || "Unknown"
  end
  
  def display_name
    user&.name || "Unknown"
  end
  
  def role_display
    user&.role&.titleize || "Member"
  end
  
  def social_links
    {
      facebook: facebook_url,
      twitter: twitter_url,
      instagram: instagram_url,
      linkedin: linkedin_url,
      youtube: youtube_url,
      spotify: spotify_url,
      soundcloud: soundcloud_url,
      pinterest: pinterest_url,
      tiktok: tiktok_url
    }.compact
  end
  
  def has_social_links?
    social_links.any?
  end
end
