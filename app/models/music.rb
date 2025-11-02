class Music < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :album
  include ImageUploader::Attachment(:image)
  mount_uploader :track, FileUploader
end
