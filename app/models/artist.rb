class Artist < ActiveRecord::Base
  has_many :tracks
  include ImageUploader::Attachment(:cover)
  include ImageUploader::Attachment(:profile_picture)

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end
end
