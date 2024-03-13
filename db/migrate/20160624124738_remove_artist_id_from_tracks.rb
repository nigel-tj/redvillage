class RemoveArtistIdFromTracks < ActiveRecord::Migration[6.1]
  def change
    remove_column :tracks, :artist_id, :string
  end
end
