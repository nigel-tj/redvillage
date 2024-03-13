class CreateVipTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :vip_tickets do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
