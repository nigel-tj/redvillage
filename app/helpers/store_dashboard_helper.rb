module StoreDashboardHelper
  def revenue_change_percentage(current, previous)
    return 0 if previous.zero?
    change = ((current - previous) / previous) * 100
    change.round(2)
  end
  
  def growth_indicator(current, previous)
    change = revenue_change_percentage(current, previous)
    if change > 0
      content_tag :span, "+#{change}%", class: "text-success"
    elsif change < 0
      content_tag :span, "#{change}%", class: "text-danger"
    else
      content_tag :span, "0%", class: "text-muted"
    end
  end
  
  def inventory_status_badge(product)
    if product.out_of_stock?
      content_tag :span, "Out of Stock", class: "badge bg-danger"
    elsif product.low_stock?
      content_tag :span, "Low Stock", class: "badge bg-warning text-dark"
    else
      content_tag :span, "In Stock", class: "badge bg-success"
    end
  end
  
  def order_status_badge(order)
    color_class = case order.status
                  when 'delivered' then 'success'
                  when 'shipped' then 'info'
                  when 'processing' then 'primary'
                  when 'cancelled' then 'danger'
                  else 'warning'
                  end
    
    content_tag :span, order.status.titleize, class: "badge bg-#{color_class}"
  end
  
  def format_currency(amount, currency = 'USD')
    symbol = case currency
             when 'USD' then '$'
             when 'EUR' then '€'
             when 'GBP' then '£'
             else '$'
             end
    "#{symbol}#{number_with_delimiter(amount.round(2))}"
  end
end

