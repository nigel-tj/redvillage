class AddCategoryToArtists < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :string, :category
class AddCategoryToArtists < ActiveRecord::Migration[7.2]
  def up
    unless column_exists?(:artists, :category)
      add_column :artists, :category, :string
    end
  end

  def down
    if column_exists?(:artists, :category)
      remove_column :artists, :category
    end
  end
end
