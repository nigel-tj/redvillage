class AddingImageUrlToEvent < ActiveRecord::Migration[7.2]
class AddingImageUrlToEvent < ActiveRecord::Migration[7.2]
  def change
     add_column :events, :image_link, :string
  end
end
