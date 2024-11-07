class Image < ApplicationRecord
  belongs_to :gallery
  #mount_uploader :image, ImageUploader
  include ImageUploader::Attachment(:file) # adds `file` and `file_attacher` methods
end
