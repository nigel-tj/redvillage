class CreateStandardTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :standard_tickets do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
