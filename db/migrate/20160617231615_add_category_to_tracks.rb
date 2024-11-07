class AddCategoryToTracks < ActiveRecord::Migration[7.2]
  def change
    add_column :tracks, :category, :string
  end
end
