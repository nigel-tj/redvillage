class CreateMalls < ActiveRecord::Migration[7.2]
  def change
    create_table :malls do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :contact_email
      t.string :contact_phone
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
