class AddCategoryToTracksAgain < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :category, :string
  end
end
