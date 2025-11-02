class CreateStorefrontSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :storefront_settings do |t|
      t.references :store, null: false, foreign_key: true, index: { unique: true }
      t.string :primary_color, default: '#007bff'
      t.string :secondary_color, default: '#6c757d'
      t.string :accent_color, default: '#28a745'
      t.string :logo
      t.string :banner_image
      t.text :custom_css
      t.string :font_family, default: 'Arial, sans-serif'
      t.string :theme, default: 'default', null: false

      t.timestamps
    end
  end
end
