class Track < ActiveRecord::Base
  belongs_to :album
  include ImageUploader::Attachment(:image)
  mount_uploader :track, FileUploader
  attr_accessor :image_cache
end
