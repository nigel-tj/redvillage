class DropAdminUsersTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :admin_users, if_exists: true
  end
end
