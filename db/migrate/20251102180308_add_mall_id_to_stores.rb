class AddMallIdToStores < ActiveRecord::Migration[7.2]
  def change
    add_reference :stores, :mall, null: true, foreign_key: true
  end
end
