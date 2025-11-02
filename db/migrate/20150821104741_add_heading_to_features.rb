class AddHeadingToFeatures < ActiveRecord::Migration[7.2]
class AddHeadingToFeatures < ActiveRecord::Migration[7.2]
  def change
    add_column :features, :heading, :string
  end
end
