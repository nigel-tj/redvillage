class AddArtistToMusics < ActiveRecord::Migration[7.2]
  def change
    add_column :musics, :artist_id, :integer
  end
end
