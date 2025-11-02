module StorefrontHelper
  def storefront_css(store)
    settings = store.storefront_settings_with_defaults
    
    content_tag :style, type: 'text/css' do
      raw(settings.custom_css_with_variables)
    end
  end
  
  def storefront_theme_class(store)
    settings = store.storefront_settings_with_defaults
    "storefront-theme-#{settings.theme}"
  end
  
  def storefront_color_variables(store)
    settings = store.storefront_settings_with_defaults
    settings.css_variables.map { |key, value| "#{key}: #{value};" }.join("\n")
  end
end

