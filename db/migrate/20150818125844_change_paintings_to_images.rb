class ChangePaintingsToImages < ActiveRecord::Migration[6.1]
  def change
    rename_table :paintings, :images
  end
end
