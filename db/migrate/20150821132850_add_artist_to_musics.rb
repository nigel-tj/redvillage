class AddArtistToMusics < ActiveRecord::Migration[6.1]
  def change
    add_column :musics, :artist_id, :integer
  end
end
