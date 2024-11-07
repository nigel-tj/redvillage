class CreateArtists < ActiveRecord::Migration[7.2]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :email
      t.integer :cell_number
      t.text :bio
      t.string :category

      t.timestamps null: false
    end
  end
end
