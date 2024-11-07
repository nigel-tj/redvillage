class AddImageToPaintings < ActiveRecord::Migration[7.2]
  def change
    add_column :paintings, :image, :string
  end
end
