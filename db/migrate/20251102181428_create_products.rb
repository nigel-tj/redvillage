class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :store, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.string :sku
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :compare_at_price, precision: 10, scale: 2
      t.integer :inventory_quantity, default: 0, null: false
      t.decimal :weight, precision: 8, scale: 2
      t.string :status, default: 'active', null: false
      t.boolean :featured, default: false, null: false

      t.timestamps
    end
    
    add_index :products, :sku, unique: true
    add_index :products, :status
    add_index :products, :featured
  end
end
