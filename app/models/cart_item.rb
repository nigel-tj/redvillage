class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validate :product_available
  
  def total_price
    quantity * product.price
  end
  
  def formatted_price
    "#{product.currency}#{sprintf('%.2f', total_price)}"
  end
  
  private
  
  def product_available
    unless product.can_purchase?(quantity)
      errors.add(:quantity, "exceeds available inventory")
    end
  end
end

