class AddColumnremove < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :token, :string
    remove_column :users, :uid, :string
  end
end
