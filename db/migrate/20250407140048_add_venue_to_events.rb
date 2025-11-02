class AddVenueToEvents < ActiveRecord::Migration[7.2]
  def up
    unless column_exists?(:events, :venue)
      add_column :events, :venue, :string
    end
  end

  def down
    if column_exists?(:events, :venue)
      remove_column :events, :venue
    end
  end
end
