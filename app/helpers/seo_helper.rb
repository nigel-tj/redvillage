module SeoHelper
  # Generate comprehensive meta tags for SEO
  def meta_tags(options = {})
    tags = []
    
    # Title
    title = options[:title] || content_for(:title) || 'The Red Cup Village - Premier Event Experience'
    tags << tag.title(title)
    tags << tag.meta(property: 'og:title', content: title)
    tags << tag.meta(name: 'twitter:title', content: title)
    
    # Description
    description = options[:description] || content_for(:description) || 
                  'The Red Cup Village is your premier destination for music events, concerts, and entertainment. Join us for unforgettable experiences with top DJs, artists, and performers.'
    tags << tag.meta(name: 'description', content: description)
    tags << tag.meta(property: 'og:description', content: description)
    tags << tag.meta(name: 'twitter:description', content: description)
    
    # Keywords
    keywords = options[:keywords] || content_for(:keywords) || 
               'events, concerts, music, DJs, artists, entertainment, tickets, nightlife, party, festival'
    tags << tag.meta(name: 'keywords', content: keywords)
    
    # Canonical URL
    canonical_url = options[:canonical] || (request.respond_to?(:url) ? request.url.split('?').first : root_url || 'https://yourdomain.com')
    tags << tag.link(rel: 'canonical', href: canonical_url)
    
    # Open Graph
    og_image = options[:image] || image_url('new_look/logo.png')
    tags << tag.meta(property: 'og:type', content: 'website')
    tags << tag.meta(property: 'og:url', content: canonical_url)
    tags << tag.meta(property: 'og:image', content: og_image)
    tags << tag.meta(property: 'og:site_name', content: 'The Red Cup Village')
    tags << tag.meta(property: 'og:locale', content: 'en_US')
    
    # Twitter Card
    tags << tag.meta(name: 'twitter:card', content: 'summary_large_image')
    tags << tag.meta(name: 'twitter:image', content: og_image)
    
    # Additional meta tags
    tags << tag.meta(name: 'robots', content: options[:robots] || 'index, follow')
    tags << tag.meta(name: 'author', content: 'The Red Cup Village')
    tags << tag.meta(name: 'viewport', content: 'width=device-width, initial-scale=1.0')
    
    # Language
    tags << tag.meta('http-equiv': 'Content-Language', content: 'en')
    
    safe_join(tags, "\n".html_safe)
  end
  
  # Generate structured data (JSON-LD)
  def structured_data(type, data = {})
    base_data = {
      '@context': 'https://schema.org',
      '@type': type
    }
    
    final_data = base_data.merge(data)
    
    content_tag :script, type: 'application/ld+json' do
      final_data.to_json.html_safe
    end
  end
  
  # Generate organization structured data
  def organization_structured_data
    structured_data('Organization', {
      name: 'The Red Cup Village',
      url: root_url || 'https://yourdomain.com',
      logo: image_url('new_look/logo.png'),
      description: 'Premier event venue and entertainment destination',
      sameAs: [
        # Add social media URLs here when available
      ]
    })
  end
    
  # Generate event structured data
  def event_structured_data(event)
    return '' unless event
    
    structured_data('Event', {
      name: event.name,
      startDate: event.date&.to_s,
      eventAttendanceMode: 'https://schema.org/OfflineEventAttendanceMode',
      eventStatus: 'https://schema.org/EventScheduled',
      location: {
        '@type': 'Place',
        name: event.venue,
        address: {
          '@type': 'PostalAddress',
          streetAddress: event.venue
        }
      },
      image: event.image_data? ? (event.image[:original]&.url || event.image.url) : nil,
      description: event.summary,
      offers: event_offers(event)
    }.compact)
  end
  
  # Generate breadcrumb structured data
  def breadcrumb_structured_data(items)
    return '' if items.empty?
    
    structured_data('BreadcrumbList', {
      itemListElement: items.each_with_index.map do |item, index|
        {
          '@type': 'ListItem',
          position: index + 1,
          name: item[:name],
          item: item[:path] ? url_for(item[:path]) : request.url
        }
      end
    })
  end
  
  private
  
  def event_offers(event)
    offers = []
    
    if event.standard_ticket_price
      offers << {
        '@type': 'Offer',
        url: event_path(event),
        price: event.standard_ticket_price,
        priceCurrency: event.currency || 'USD',
        availability: 'https://schema.org/InStock',
        validFrom: event.created_at&.iso8601
      }
    end
    
    if event.vip_ticket_price
      offers << {
        '@type': 'Offer',
        url: event_path(event),
        price: event.vip_ticket_price,
        priceCurrency: event.currency || 'USD',
        availability: 'https://schema.org/InStock',
        validFrom: event.created_at&.iso8601
      }
    end
    
    offers
  end
end

