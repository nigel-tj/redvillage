class ReAddSlugToStores < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:stores, :slug)
      add_column :stores, :slug, :string
      add_index :stores, :slug, unique: true
    end
  end
end
