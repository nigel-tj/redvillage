class AddAlbumToTracks < ActiveRecord::Migration[7.2]
  def change
    add_column :tracks, :album_id, :integer
    add_column :tracks, :artist_name, :string
  end
end
