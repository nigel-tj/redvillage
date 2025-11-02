class Gallery < ActiveRecord::Base
  has_many :images
  include ImageUploader::Attachment(:image)
end
