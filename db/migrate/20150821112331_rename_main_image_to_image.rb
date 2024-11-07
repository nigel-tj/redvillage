class RenameMainImageToImage < ActiveRecord::Migration[7.2]
  def change
    rename_column :features, :main_image, :image
  end
end
