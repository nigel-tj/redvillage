class RenameMainImageToImage < ActiveRecord::Migration[6.1]
  def change
    rename_column :features, :main_image, :image
  end
end
