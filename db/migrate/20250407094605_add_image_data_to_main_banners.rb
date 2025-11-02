class AddImageDataToMainBanners < ActiveRecord::Migration[7.2]
  def change
    add_column :main_banners, :image_data, :text
  end
end
