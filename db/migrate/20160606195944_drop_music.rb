class DropMusic < ActiveRecord::Migration[6.1]
  def change
    drop_table :musics
  end
end
