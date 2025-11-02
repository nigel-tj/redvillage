class CreateProductImages < ActiveRecord::Migration[7.2]
  def change
    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.string :image
      t.string :alt_text
      t.integer :position, default: 0, null: false

      t.timestamps
    end
    
    add_index :product_images, :position
  end
end
