class Payment < ActiveRecord::Base
  belongs_to :order
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :status, inclusion: { in: %w[pending paid failed refunded] }
  
  scope :paid, -> { where(status: 'paid') }
  scope :pending, -> { where(status: 'pending') }
  scope :failed, -> { where(status: 'failed') }
  
  before_validation :set_defaults
  
  def formatted_amount
    "#{currency_symbol}#{sprintf('%.2f', amount)}"
  end
  
  def paid?
    status == 'paid'
  end
  
  def pending?
    status == 'pending'
  end
  
  def failed?
    status == 'failed'
  end
  
  def mark_as_paid!
    update(status: 'paid')
    order.processing! if order.pending?
  end
  
  def mark_as_failed!
    update(status: 'failed')
  end
  
  private
  
  def set_defaults
    self.currency ||= order&.currency || 'USD'
    self.status ||= 'pending'
    self.amount ||= order&.total_amount || 0
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

