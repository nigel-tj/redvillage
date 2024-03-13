class AddingImageUrlToEvent < ActiveRecord::Migration[6.1]
  def change
     add_column :events, :image_link, :string
  end
end
