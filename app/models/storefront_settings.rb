class StorefrontSettings < ActiveRecord::Base
  belongs_to :store
  
  validates :theme, presence: true
  validates :primary_color, :secondary_color, :accent_color, format: { 
    with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, 
    message: "must be a valid hex color code" 
  }, allow_nil: true
  
  # Theme options
  THEMES = %w[default modern minimal elegant bold]
  
  after_initialize :set_defaults
  
  def css_variables
    {
      '--primary-color' => primary_color || '#007bff',
      '--secondary-color' => secondary_color || '#6c757d',
      '--accent-color' => accent_color || '#28a745',
      '--font-family' => font_family || 'Arial, sans-serif'
    }
  end
  
  def custom_css_with_variables
    css_vars = css_variables.map { |key, value| "#{key}: #{value};" }.join("\n")
    ":root {\n#{css_vars}\n}\n\n#{custom_css.to_s}"
  end
  
  private
  
  def set_defaults
    self.theme ||= 'default'
    self.primary_color ||= '#007bff'
    self.secondary_color ||= '#6c757d'
    self.accent_color ||= '#28a745'
    self.font_family ||= 'Arial, sans-serif'
  end
end

