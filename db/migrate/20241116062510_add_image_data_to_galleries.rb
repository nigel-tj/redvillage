class AddImageDataToGalleries < ActiveRecord::Migration[7.2]
  def change
    add_column :galleries, :image_data, :text
  end
end
