class AddSlugAndStatusToStores < ActiveRecord::Migration[7.2]
  def change
    add_column :stores, :slug, :string
    add_column :stores, :active, :boolean, default: true, null: false
    add_index :stores, :slug, unique: true
  end
end
