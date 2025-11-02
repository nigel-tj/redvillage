class TicketListing < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  validates :ticket_type, presence: true, inclusion: { in: %w[standard vip] }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :sold_quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :status, presence: true, inclusion: { in: %w[available sold pending expired] }
  validates :currency, presence: true
  
  scope :available, -> { where(status: 'available') }
  scope :by_event, ->(event_id) { where(event_id: event_id) }
  scope :by_type, ->(type) { where(ticket_type: type) }
  scope :active, -> { where(status: ['available', 'pending']) }
  scope :for_sale, -> { available.where('quantity > sold_quantity') }
  
  before_validation :set_defaults, on: :create
  before_validation :validate_sold_quantity
  
  def available_quantity
    quantity - sold_quantity
  end
  
  def is_available?
    status == 'available' && available_quantity > 0
  end
  
  def is_sold_out?
    sold_quantity >= quantity
  end
  
  def mark_sold!
    update(status: 'sold') if is_sold_out?
  end
  
  def formatted_price
    "#{currency} #{sprintf('%.2f', price)}"
  end
  
  def formatted_original_price
    return nil unless original_price
    "#{currency} #{sprintf('%.2f', original_price)}"
  end
  
  def has_discount?
    original_price && original_price > price
  end
  
  def discount_percentage
    return 0 unless has_discount?
    ((original_price - price) / original_price * 100).round
  end
  
  private
  
  def set_defaults
    self.status ||= 'available'
    self.sold_quantity ||= 0
    self.currency ||= 'USD'
    self.ticket_type ||= 'standard'
  end
  
  def validate_sold_quantity
    if sold_quantity && quantity && sold_quantity > quantity
      errors.add(:sold_quantity, 'cannot exceed quantity')
    end
  end
end

