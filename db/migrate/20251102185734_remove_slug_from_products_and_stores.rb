class RemoveSlugFromProductsAndStores < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :slug, :string
    remove_index :products, :slug if index_exists?(:products, :slug)
    remove_column :stores, :slug, :string
    remove_index :stores, :slug if index_exists?(:stores, :slug)
  end
end
