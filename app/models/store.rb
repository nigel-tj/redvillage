class Store < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]
  
  # Associations
  belongs_to :user
  belongs_to :mall, optional: true
  has_one :storefront_settings, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :carts, dependent: :destroy
  
  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :description, presence: true
  validates :user_id, presence: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_mall, ->(mall_id) { where(mall_id: mall_id) }
  scope :without_mall, -> { where(mall_id: nil) }
  
  # Callbacks
  before_validation :set_default_active, on: :create
  
  # Methods
  def activate!
    update(active: true)
  end
  
  def deactivate!
    update(active: false)
  end
  
  def owner?(current_user)
    user_id == current_user&.id
  end
  
  # Currency method - uses database field if present, defaults to USD
  
  def storefront_settings_with_defaults
    storefront_settings || build_storefront_settings
  end
  
  def total_sales
    orders.completed.sum(:total_amount)
  end
  
  def total_orders
    orders.count
  end
  
  def products_count
    products.count
  end
  
  private
  
  def set_default_active
    self.active = true if active.nil?
  end
  
  # FriendlyId: regenerate slug if name changes
  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
