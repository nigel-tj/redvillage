class AddVenueToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :venue, :string
  end
end
