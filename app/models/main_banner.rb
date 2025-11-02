class MainBanner < ActiveRecord::Base
  include ImageUploader::Attachment.new(:image) # Uses the new Shrine syntax
  
  validates :name, presence: true
  validates :title, presence: true
  validates :page, presence: true
  
  # Controls visibility of ticket and promo section in banner
  attribute :ticket_promo, :boolean, default: false
end
