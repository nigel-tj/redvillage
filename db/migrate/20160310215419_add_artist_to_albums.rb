class AddArtistToAlbums < ActiveRecord::Migration[7.2]
  def change
    add_column :albums, :artist_id, :integer
  end
end
