class AddImageDataToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :image_data, :text
  end
end
