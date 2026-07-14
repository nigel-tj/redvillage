class Music < ActiveRecord::Base
  belongs_to :album
  include ImageUploader::Attachment(:image)
end
