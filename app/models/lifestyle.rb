class Lifestyle < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
end
