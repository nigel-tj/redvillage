class Artist < ActiveRecord::Base
  has_many :tracks
  include ImageUploader::Attachment(:cover)           
  include ImageUploader::Attachment(:profile_picture) 
end
