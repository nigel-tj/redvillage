class AddArtistNameToAlbums < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :artist_name, :string
  end
end
