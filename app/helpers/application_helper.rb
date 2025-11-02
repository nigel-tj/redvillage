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

  def breadcrumb_items
    breadcrumbs = []

    # Always start with Home
    breadcrumbs << { name: 'Home', path: root_path }

    # Map controller actions to breadcrumb names
    breadcrumb_map = {
      'visitors#about_us' => 'About',
      'visitors#gallery' => 'Gallery',
      'visitors#contact_us' => 'Contact',
      'visitors#blog' => 'Blog',
      'visitors#blog_details' => 'Blog Details',
      'visitors#faq' => 'FAQ',
      'visitors#top_dj' => 'Top DJ',
      'visitors#schedule' => 'Schedule',
      'visitors#event_new_look' => 'Event',
      'visitors#events_list_new_look' => 'Events',
      'visitors#featured_events' => 'Featured Events',
      'visitors#team' => 'Team',
      'visitors#social' => 'Social',
      'visitors#stage' => 'Stage',
      'visitors#portfolio' => 'Portfolio',
      'visitors#store' => 'Store',
      'visitors#videos' => 'Videos',
      'visitors#news' => 'News'
    }

    controller_action = "#{controller_name}##{action_name}"
    if breadcrumb_map.key?(controller_action)
      breadcrumbs << { name: breadcrumb_map[controller_action], path: nil }
    end

    breadcrumbs
  end

  def render_breadcrumbs
    items = breadcrumb_items
    return '' if items.empty?

    content_tag :div, class: 'breadcrump-content' do
      items.each_with_index do |item, index|
        if index > 0
          concat content_tag(:span, class: 'icon') { content_tag(:i, '', class: 'fas fa-chevron-right') }
        end

        classes = ['page-name']
        classes << 'active' if item[:path].nil?

        if item[:path]
          concat link_to(item[:name], item[:path], class: classes.join(' '))
        else
          concat content_tag(:span, item[:name], class: classes.join(' '))
        end
      end
    end
  end
end
