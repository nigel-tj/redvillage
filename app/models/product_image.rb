class ProductImage < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
  
  belongs_to :product
  
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :ordered, -> { order(:position, :created_at) }
  
  default_scope { order(:position, :created_at) }
  
  def image_url(version = :medium)
    image&.url(version)
  end
end


