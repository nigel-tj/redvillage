class CreateAds < ActiveRecord::Migration[7.2]
  def change
    create_table :ads do |t|
      t.string :title, null: false
      t.text :image
      t.text :image_data
      t.string :url
      t.integer :ad_spot_id, null: false
      t.date :start_date
      t.date :end_date
      t.boolean :active, default: true, null: false
      t.integer :impressions, default: 0, null: false
      t.integer :clicks, default: 0, null: false
      t.string :advertiser_name
      t.string :advertiser_email
      t.text :notes

      t.timestamps
    end
    
    add_index :ads, :ad_spot_id
    add_index :ads, :active
    add_index :ads, [:ad_spot_id, :active]
    add_index :ads, [:start_date, :end_date]
    add_foreign_key :ads, :ad_spots, on_delete: :restrict
  end
end
