class Feature < ActiveRecord::Base
  # paginates_per 4
  include ImageUploader::Attachment(:image) 
end
