class AddCategoryToGallery < ActiveRecord::Migration[6.1]
  def change
    add_column :galleries, :category, :string
  end
end
