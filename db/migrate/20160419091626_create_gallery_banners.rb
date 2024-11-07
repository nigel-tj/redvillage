class CreateGalleryBanners < ActiveRecord::Migration[7.2]
  def change
    create_table :gallery_banners do |t|
      t.string :name
      t.text :description
      t.string :link
      t.string :image
      t.boolean :active

      t.timestamps null: false
    end
  end
end
