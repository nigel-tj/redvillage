class AddImageDataToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :profile_picture_data, :text
    add_column :profiles, :cover_image_data, :text
  end
end
