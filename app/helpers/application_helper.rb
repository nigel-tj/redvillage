module ApplicationHelper
  def active_class(path)
    current_page?(path) ? 'active' : ''
  end
  
  # Helper to get the image URL from a Shrine attachment
  def shrine_image_url(record, field, version = nil)
    return nil unless record && record.send(field)
    
    if version && record.send(field)[version]
      record.send(field)[version].url
    else
      record.send(field).url
    end
  end

  def format_price(price, currency)
    return '' unless price.present?
    
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
    number = number_with_precision(price, precision: precision)
    
    case currency
    when 'EUR', 'CHF'
      "#{number} #{symbol}"
    else
      "#{symbol}#{number}"
    end
  end
end
