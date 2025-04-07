class MainBanner < ActiveRecord::Base
  include ImageUploader::Attachment.new(:image) # Uses the new Shrine syntax
end
