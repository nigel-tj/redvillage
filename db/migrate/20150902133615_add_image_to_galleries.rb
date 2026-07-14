class AddImageToGalleries < ActiveRecord::Migration[7.2]
  def change
    add_column :galleries, :image, :string
  end
end
