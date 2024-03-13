class AddAlbumToMusics < ActiveRecord::Migration[6.1]
  def change
    add_column :musics, :album_id, :integer
  end
end
