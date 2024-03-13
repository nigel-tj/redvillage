class AddHeadingToFeatures < ActiveRecord::Migration[6.1]
  def change
    add_column :features, :heading, :string
  end
end
