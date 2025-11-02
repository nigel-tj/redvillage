class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, :total_price, presence: true, numericality: { greater_than: 0 }
  
  before_validation :calculate_total_price
  after_create :decrease_product_inventory
  
  def calculate_total_price
    self.unit_price ||= product&.price || 0
    self.total_price = (unit_price * quantity).round(2) if unit_price && quantity
  end
  
  private
  
  def decrease_product_inventory
    return unless product.present?
    product.decrease_inventory!(quantity) if product.can_purchase?(quantity)
  end
end

