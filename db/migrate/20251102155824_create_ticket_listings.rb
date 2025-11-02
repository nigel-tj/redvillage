class CreateTicketListings < ActiveRecord::Migration[7.2]
  def change
    create_table :ticket_listings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :ticket_type, null: false, default: 'standard'
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :sold_quantity, null: false, default: 0
      t.text :description
      t.string :status, null: false, default: 'available'
      t.decimal :original_price, precision: 10, scale: 2
      t.string :currency, default: 'USD', null: false

      t.timestamps
    end
    
    add_index :ticket_listings, [:event_id, :status]
    add_index :ticket_listings, [:user_id, :status]
    add_index :ticket_listings, :ticket_type
  end
end
