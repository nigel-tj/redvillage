class Product < ActiveRecord::Base
  include Pricable
  include Stockable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]
  
  belongs_to :store
  has_many :product_images, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :orders, through: :order_items
  
  # Validations
  validates :name, presence: true, length: { maximum: 200 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, uniqueness: { scope: :store_id, allow_nil: true }
  validates :status, inclusion: { in: %w[active inactive out_of_stock] }
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :featured, -> { where(featured: true) }
  scope :in_stock, -> { where('inventory_quantity > 0') }
  scope :by_store, ->(store_id) { where(store_id: store_id) }
  
  # Callbacks
  before_validation :set_defaults
  after_save :update_status_based_on_inventory
  
  def primary_image
    product_images.order(:position).first
  end
  
  def has_images?
    product_images.any?
  end
  
  def status
    super || 'active'
  end
  
  private
  
  def set_defaults
    self.status ||= 'active'
    self.inventory_quantity ||= 0
    self.featured ||= false
  end
  
  def currency
    store&.currency || 'USD'
  end
  
  def update_status_based_on_inventory
    if inventory_quantity.zero? && status == 'active'
      update_column(:status, 'out_of_stock')
    elsif inventory_quantity > 0 && status == 'out_of_stock'
      update_column(:status, 'active')
    end
  end
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end
end

