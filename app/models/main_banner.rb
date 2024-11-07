class MainBanner < ActiveRecord::Base
  include ImageUploader::Attachment(:image) # This replaces `mount_uploader`
end
