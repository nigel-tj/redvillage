class Gallery < ActiveRecord::Base
  #attr_accessible :name
  attr_accessor :image_data
  has_many :images
  include ImageUploader::Attachment(:image)
end
