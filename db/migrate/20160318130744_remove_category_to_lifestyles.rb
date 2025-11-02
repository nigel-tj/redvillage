class RemoveCategoryToLifestyles < ActiveRecord::Migration[7.2]
class RemoveCategoryToLifestyles < ActiveRecord::Migration[7.2]
  def change
    drop_table :lifestyles
  end
end
