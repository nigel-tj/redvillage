class AddFileDataToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :file_data, :text
  end
end
