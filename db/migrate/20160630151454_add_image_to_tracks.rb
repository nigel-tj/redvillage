class AddImageToTracks < ActiveRecord::Migration[7.2]
class AddImageToTracks < ActiveRecord::Migration[7.2]
  def change
    add_column :tracks, :image, :string
  end
end
