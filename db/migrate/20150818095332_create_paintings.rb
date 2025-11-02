class CreatePaintings < ActiveRecord::Migration[7.2]
class CreatePaintings < ActiveRecord::Migration[7.2]
  def change
    create_table :paintings do |t|
      t.integer :gallery_id
      t.string :name
      t.timestamps
    end
  end
end
