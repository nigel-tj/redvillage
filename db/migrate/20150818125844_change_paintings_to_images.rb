class ChangePaintingsToImages < ActiveRecord::Migration[7.2]
class ChangePaintingsToImages < ActiveRecord::Migration[7.2]
  def change
    rename_table :paintings, :images
  end
end
