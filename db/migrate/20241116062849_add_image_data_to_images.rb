class AddImageDataToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :image_data, :text
  end
end
