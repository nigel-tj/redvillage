class Image < ActiveRecord::Base
  belongs_to :gallery
  #mount_uploader :image, ImageUploader
  include ImageUploader::Attachment(:image) # adds `file` and `file_attacher` methods
  attr_accessor :remote_image_url

  before_validation :download_remote_image, if: -> { remote_image_url.present? }

  private

  def download_remote_image
    downloaded_file = Down.download(remote_image_url)
    self.image = downloaded_file # Assign to Shrine attachment
  rescue Down::Error => e
    errors.add(:remote_image_url, "is invalid or cannot be downloaded")
  end
end
