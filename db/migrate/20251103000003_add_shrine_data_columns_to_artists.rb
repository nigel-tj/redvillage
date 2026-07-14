class AddShrineDataColumnsToArtists < ActiveRecord::Migration[7.2]
  def change
    # Shrine attachments declared on Artist (cover, profile_picture) require *_data JSON columns.
    add_column :artists, :cover_data, :json unless column_exists?(:artists, :cover_data)
    add_column :artists, :profile_picture_data, :json unless column_exists?(:artists, :profile_picture_data)
  end
end
