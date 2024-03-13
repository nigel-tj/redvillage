class AddImageToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :image, :string
  end
end
