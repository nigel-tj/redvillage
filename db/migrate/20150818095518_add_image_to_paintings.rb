class AddImageToPaintings < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :image, :string
  end
end
