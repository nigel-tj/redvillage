class Order < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :payments, dependent: :destroy
  
  validates :status, inclusion: { in: %w[pending processing shipped delivered cancelled refunded] }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  
  scope :by_status, ->(status) { where(status: status) }
  scope :pending, -> { where(status: 'pending') }
  scope :completed, -> { where(status: ['delivered', 'shipped']) }
  scope :by_store, ->(store_id) { where(store_id: store_id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  
  before_validation :set_defaults
  before_save :calculate_total_from_items
  after_create :update_total_amount
  
  def formatted_total
    "#{currency_symbol}#{sprintf('%.2f', total_amount)}"
  end
  
  def pending?
    status == 'pending'
  end
  
  def paid?
    payments.any? { |p| p.status == 'paid' }
  end
  
  def processing!
    update(status: 'processing')
  end
  
  def shipped!
    update(status: 'shipped')
  end
  
  def delivered!
    update(status: 'delivered')
  end
  
  def cancel!
    update(status: 'cancelled')
    order_items.each do |item|
      item.product.increase_inventory!(item.quantity)
    end
  end
  
  private
  
  def set_defaults
    self.status ||= 'pending'
    self.currency ||= store&.currency || 'USD'
  end
  
  def calculate_total_from_items
    if order_items.any?
      self.total_amount = order_items.sum { |item| item.total_price || (item.quantity * item.unit_price) }
    end
  end
  
  def calculate_total
    calculate_total_from_items
    save if persisted?
  end
  
  def update_total_amount
    calculate_total_from_items
    save if persisted? && total_amount_changed?
  end
  
  def currency_symbol
    case currency
    when 'USD' then '$'
    when 'EUR' then '€'
    when 'GBP' then '£'
    when 'JPY' then '¥'
    else '$'
    end
  end
end

