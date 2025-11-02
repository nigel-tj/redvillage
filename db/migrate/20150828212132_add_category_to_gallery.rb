class AddCategoryToGallery < ActiveRecord::Migration[7.2]
class AddCategoryToGallery < ActiveRecord::Migration[7.2]
  def change
    add_column :galleries, :category, :string
  end
end
