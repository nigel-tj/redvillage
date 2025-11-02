module StorefrontHelper
  def storefront_css(store)
    return '' unless store.present?
    
    settings = store.storefront_settings_with_defaults
    
    content_tag :style, type: 'text/css', id: 'storefront-custom-css' do
      raw(settings.custom_css_with_variables)
    end
  end
  
  def storefront_css_in_head(store)
    return '' unless store.present?
    
    settings = store.storefront_settings_with_defaults
    
    content_tag :style, type: 'text/css', id: 'storefront-custom-css' do
      raw(settings.custom_css_with_variables)
    end
  end
  
  def storefront_theme_class(store)
    return '' unless store.present?
    settings = store.storefront_settings_with_defaults
    "storefront-theme-#{settings.theme}"
  end
  
  def storefront_color_variables(store)
    return '' unless store.present?
    settings = store.storefront_settings_with_defaults
    settings.css_variables.map { |key, value| "#{key}: #{value};" }.join("\n")
  end
  
  def storefront_body_class(store)
    return '' unless store.present?
    settings = store.storefront_settings_with_defaults
    classes = ['storefront-page']
    classes << "theme-#{settings.theme}" if settings.theme.present?
    classes.join(' ')
  end
end


