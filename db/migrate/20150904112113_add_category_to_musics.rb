class AddCategoryToMusics < ActiveRecord::Migration[6.1]
  def change
    add_column :musics, :category, :string
  end
end
