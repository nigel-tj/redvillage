class AddFeaturedToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :featured, :boolean
  end
end
