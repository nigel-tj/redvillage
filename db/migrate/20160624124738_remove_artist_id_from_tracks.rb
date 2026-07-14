class RemoveArtistIdFromTracks < ActiveRecord::Migration[7.2]
  def change
    remove_column :tracks, :artist_id, :string
  end
end
