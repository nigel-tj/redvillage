class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'pending', null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.string :currency, default: 'USD', null: false
      t.text :shipping_address
      t.text :billing_address
      t.string :shipping_name
      t.string :shipping_phone
      t.string :stripe_payment_intent_id

      t.timestamps
    end
    
    add_index :orders, :status
    add_index :orders, :stripe_payment_intent_id
  end
end
