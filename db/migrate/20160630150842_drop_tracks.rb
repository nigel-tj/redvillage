class DropTracks < ActiveRecord::Migration[7.2]
  def change
    drop_table :tracks
  end
end
