class DropMusic < ActiveRecord::Migration[7.2]
  def change
    drop_table :musics
  end
end
