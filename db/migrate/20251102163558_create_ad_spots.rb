class CreateAdSpots < ActiveRecord::Migration[7.2]
  def change
    create_table :ad_spots do |t|
      t.string :name, null: false
      t.string :page, null: false
      t.string :position, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.string :currency, default: 'USD', null: false
      t.boolean :active, default: true, null: false
      t.text :description

      t.timestamps
    end
    
    add_index :ad_spots, :page
    add_index :ad_spots, :position
    add_index :ad_spots, :active
    add_index :ad_spots, [:page, :position], unique: true
  end
end
