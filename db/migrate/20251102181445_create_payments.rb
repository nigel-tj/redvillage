class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :currency, default: 'USD', null: false
      t.string :status, default: 'pending', null: false
      t.string :stripe_charge_id
      t.string :stripe_payment_intent_id
      t.string :payment_method

      t.timestamps
    end
    
    add_index :payments, :status
    add_index :payments, :stripe_payment_intent_id
  end
end
