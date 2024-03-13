class AddImageToGalleries < ActiveRecord::Migration[6.1]
  def change
    add_column :galleries, :image, :string
  end
end
