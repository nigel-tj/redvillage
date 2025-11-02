class AddAlbumToMusics < ActiveRecord::Migration[7.2]
class AddAlbumToMusics < ActiveRecord::Migration[7.2]
  def change
    add_column :musics, :album_id, :integer
  end
end
