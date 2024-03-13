class CreateFeatureBanners < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_banners do |t|
      t.string :name
      t.text :description
      t.string :image
      t.string :link

      t.timestamps null: false
    end
  end
end
