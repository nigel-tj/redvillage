class AddProfileFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :role, :integer, null: false, default: 0
    add_column :users, :provider, :string
    add_column :users, :uid, :string

    add_index :users, :role
    add_index :users, [:provider, :uid], unique: true
  end
end
