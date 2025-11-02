module Pricable
  extend ActiveSupport::Concern

  included do
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  def formatted_price
    currency_val = respond_to?(:currency) ? currency : 'USD'
    symbol = currency_symbol(currency_val)
    "#{symbol}#{sprintf('%.2f', price)}"
  end

  def has_discount?
    compare_at_price.present? && compare_at_price > price
  end

  def discount_percentage
    return 0 unless has_discount?
    ((compare_at_price - price) / compare_at_price * 100).round
  end

  def discount_amount
    return 0 unless has_discount?
    compare_at_price - price
  end

  private

  def currency_symbol(currency_code = 'USD')
    case currency_code
    when 'USD' then '$'
    when 'EUR' then '€'
    when 'GBP' then '£'
    when 'JPY' then '¥'
    else '$'
    end
  end
end

