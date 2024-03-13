class AddImageMusics < ActiveRecord::Migration[6.1]
  def change
    add_column :musics, :image, :string
  end
end
