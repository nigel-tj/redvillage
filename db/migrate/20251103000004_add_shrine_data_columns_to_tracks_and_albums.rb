class AddShrineDataColumnsToTracksAndAlbums < ActiveRecord::Migration[7.2]
  def change
    # Track declares Shrine attachments :image (ImageUploader) and :track (SoundUploader)
    # Album declares Shrine attachment :image (ImageUploader). These require *_data JSON columns.
    add_column :tracks, :image_data, :json unless column_exists?(:tracks, :image_data)
    add_column :tracks, :track_data, :json unless column_exists?(:tracks, :track_data)
    add_column :albums, :image_data, :json unless column_exists?(:albums, :image_data)
  end
end
