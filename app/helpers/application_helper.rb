module ApplicationHelper
  include SeoHelper
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

  # Render an ad for a specific page and position
  def render_ad(page, position, options = {})
    ad_spot = AdSpot.active.for_page(page.to_s).by_position(position.to_s).first
    return '' unless ad_spot&.active?

    ad = ad_spot.current_active_ad
    return '' unless ad

    # Track impression
    ad.impression! if ad.persisted?

    css_class = options[:class] || "ad-container ad-#{page}-#{position}"
    style = options[:style] || "width: #{ad_spot.width}px; height: #{ad_spot.height}px;"
    
    content_tag :div, class: css_class, style: style do
      if ad.url.present?
        link_to click_ad_path(ad), class: 'ad-link', target: '_blank', rel: 'nofollow sponsored' do
          concat ad_image_tag(ad, ad_spot)
          concat content_tag(:div, '', class: 'ad-label') if options[:show_label]
        end
      else
        concat ad_image_tag(ad, ad_spot)
        concat content_tag(:div, '', class: 'ad-label') if options[:show_label]
      end
    end
  end

  # Helper to render ad image with proper sizing
  def ad_image_tag(ad, ad_spot)
    if ad.image_data?
      image_url = if ad.image[:original]
                    ad.image[:original].url
                  else
                    ad.image.url
                  end
      
      image_tag image_url,
                alt: ad.title,
                style: "max-width: #{ad_spot.width}px; max-height: #{ad_spot.height}px; width: 100%; height: auto; object-fit: contain;",
                class: 'ad-image'
    else
      content_tag :div, 'Ad', class: 'ad-placeholder', style: "width: #{ad_spot.width}px; height: #{ad_spot.height}px; display: flex; align-items: center; justify-content: center; background: #f0f0f0; color: #999;"
    end
  end

  # Get current page identifier for ad rendering
  def current_page_for_ads
    case controller_name
    when 'visitors'
      case action_name
      when 'index' then 'home'
      when 'about_us' then 'about'
      when 'gallery' then 'gallery'
      when 'event_new_look', 'events_list_new_look', 'featured_events' then 'events'
      when 'team' then 'team'
      when 'schedule' then 'schedule'
      when 'blog', 'blog_details' then 'blog'
      when 'faq' then 'faq'
      when 'contact_us' then 'contact'
      else 'home'
      end
    when 'events' then 'events'
    when 'galleries' then 'gallery'
    when 'artists', 'profiles_listings' then 'artists'
    when 'videos' then 'videos'
    when 'tracks' then 'music'
    else 'home'
    end
  end
end
