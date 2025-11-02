class Album < ActiveRecord::Base
  has_many :tracks
  include ImageUploader::Attachment(:image)
end
