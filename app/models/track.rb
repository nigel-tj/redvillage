class Track < ActiveRecord::Base
  belongs_to :album, optional: true
  include ImageUploader::Attachment(:image)
  include SoundUploader::Attachment(:track)
  attr_accessor :image_cache
end
