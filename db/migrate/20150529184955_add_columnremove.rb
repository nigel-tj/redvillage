class AddColumnremove < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :token, :string
    remove_column :users, :uid, :string
  end
end
