class AddCategoryToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :category, :string
  end
end
