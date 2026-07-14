class CreateStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :cover
      t.string :email
      t.string :contact_number
      t.text :description

      t.timestamps null: false
    end
  end
end
