class CreateMusics < ActiveRecord::Migration[6.1]
  def change
    create_table :musics do |t|
      t.string :track_title
      t.text :cover
      t.text :intro
      t.text :thumb

      t.timestamps null: false
    end
  end
end
