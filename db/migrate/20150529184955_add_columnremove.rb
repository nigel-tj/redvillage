class AddColumnremove < ActiveRecord::Migration[7.2]
  def up
    remove_column :users, :token, :string if column_exists?(:users, :token)
    remove_column :users, :uid, :string if column_exists?(:users, :uid)
  end

  def down
    add_column :users, :token, :string unless column_exists?(:users, :token)
    add_column :users, :uid, :string unless column_exists?(:users, :uid)
  end
end
