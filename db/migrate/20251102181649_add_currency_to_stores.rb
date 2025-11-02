class AddCurrencyToStores < ActiveRecord::Migration[7.2]
  def change
    add_column :stores, :currency, :string, default: 'USD', null: false
  end
end
