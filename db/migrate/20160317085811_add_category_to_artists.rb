class AddCategoryToArtists < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :string, :category
  end
end
