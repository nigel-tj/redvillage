class CreateTracks < ActiveRecord::Migration[7.2]
  def change
    create_table :tracks do |t|
      t.string :title
      t.integer :artist_id
      t.string :cover
      t.string :intro
      t.string :thumb

      t.timestamps null: false
    end
  end
end
