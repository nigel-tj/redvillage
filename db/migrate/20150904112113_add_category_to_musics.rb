class AddCategoryToMusics < ActiveRecord::Migration[7.2]
class AddCategoryToMusics < ActiveRecord::Migration[7.2]
  def change
    add_column :musics, :category, :string
  end
end
