class RemoveCategoryToLifestyles < ActiveRecord::Migration[6.1]
  def change
    drop_table :lifestyles
  end
end
