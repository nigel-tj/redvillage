class Cart < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :store
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  validates :store_id, presence: true
  
  def total_items
    cart_items.sum(:quantity)
  end
  
  def total_price
    cart_items.sum { |item| item.total_price || (item.quantity * item.product.price) }
  end
  
  def formatted_total
    "$#{sprintf('%.2f', total_price)}"
  end
  
  def empty?
    cart_items.empty?
  end
  
  def add_product(product, quantity = 1)
    return false unless product.can_purchase?(quantity)
    
    cart_item = cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = cart_item.persisted? ? cart_item.quantity + quantity : quantity
    cart_item.save
  end
  
  def remove_product(product)
    cart_items.where(product: product).destroy_all
  end
  
  def update_quantity(product, quantity)
    cart_item = cart_items.find_by(product: product)
    return false unless cart_item
    
    if quantity <= 0
      cart_item.destroy
    else
      return false unless product.can_purchase?(quantity)
      cart_item.update(quantity: quantity)
    end
  end
  
  class << self
    def find_or_create_for(user, store, session_id = nil)
      cart = if user
        find_or_create_by(user: user, store: store)
      else
        find_or_create_by(store: store, session_id: session_id)
      end
      cart
    end
  end
end

