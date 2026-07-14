class AddShrineImageDataToFeaturesAndLifestyles < ActiveRecord::Migration[7.2]
  def change
    add_column :features, :image_data, :json
    add_column :lifestyles, :image_data, :json
  end
end
