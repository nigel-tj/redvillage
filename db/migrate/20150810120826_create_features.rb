class CreateFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :features do |t|
      t.text :link
      t.text :main_image
      t.text :intro
      t.text :thumb

      t.timestamps null: false
    end
  end
end
