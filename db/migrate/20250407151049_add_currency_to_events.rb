class AddCurrencyToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :currency, :string, default: 'USD', null: false
  end
end
