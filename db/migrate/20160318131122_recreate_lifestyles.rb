class RecreateLifestyles < ActiveRecord::Migration[7.2]
  def change
    create_table :lifestyles do |t|
      t.string :image
      t.string :title
      t.string :link
      t.string :intro
      t.string :category

      t.timestamps null: false
    end
  end
end
