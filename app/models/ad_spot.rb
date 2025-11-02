class AdSpot < ActiveRecord::Base
  has_many :ads, dependent: :restrict_with_error
  
  validates :name, presence: true
  validates :page, presence: true
  validates :position, presence: true
  validates :width, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :page, uniqueness: { scope: :position, message: "and position combination must be unique" }
  
  scope :active, -> { where(active: true) }
  scope :for_page, ->(page) { where(page: page) }
  scope :by_position, ->(position) { where(position: position) }
  
  def format_price
    helper = Object.new.extend(ActionView::Helpers::NumberHelper)
    symbol = case currency
      when 'USD' then '$'
      when 'EUR' then '€'
      when 'GBP' then '£'
      when 'JPY' then '¥'
      when 'AUD' then 'A$'
      when 'CAD' then 'C$'
      when 'CHF' then 'Fr'
      when 'CNY' then '¥'
      when 'INR' then '₹'
      else '$'
    end
    
    precision = ['JPY', 'CNY', 'INR'].include?(currency) ? 0 : 2
    number = helper.number_with_precision(price, precision: precision)
    
    case currency
    when 'EUR', 'CHF'
      "#{number} #{symbol}"
    else
      "#{symbol}#{number}"
    end
  end
  
  def current_active_ad
    ads.active
       .where('(start_date IS NULL OR start_date <= ?) AND (end_date IS NULL OR end_date >= ?)', 
              Date.current, Date.current)
       .order(created_at: :desc)
       .first
  end
end

