class AddSlugToMalls < ActiveRecord::Migration[7.2]
  def change
    add_column :malls, :slug, :string
    add_index :malls, :slug, unique: true
  end
end
