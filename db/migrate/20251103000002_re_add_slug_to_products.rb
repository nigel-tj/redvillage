class ReAddSlugToProducts < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:products, :slug)
      add_column :products, :slug, :string
      add_index :products, :slug, unique: true
    end
  end
end
