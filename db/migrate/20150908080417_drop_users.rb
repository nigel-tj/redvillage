class DropUsers < ActiveRecord::Migration[7.2]
  def up
    # Remove foreign key constraints first
    remove_foreign_key :vip_tickets, :users if foreign_key_exists?(:vip_tickets, :users)
    remove_foreign_key :standard_tickets, :users if foreign_key_exists?(:standard_tickets, :users)
    
    # Then drop the table
    drop_table :users if table_exists?(:users)
  end

  def down
    create_table :users do |t|
      t.string :email
      t.string :provider
      t.string :uid
      
      t.timestamps null: false
    end
  end
end
