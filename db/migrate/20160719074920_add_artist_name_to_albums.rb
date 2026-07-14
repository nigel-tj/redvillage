class AddArtistNameToAlbums < ActiveRecord::Migration[7.2]
  def change
    add_column :albums, :artist_name, :string
  end
end
