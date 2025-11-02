class AddCoverAndProfilePictureToArtists < ActiveRecord::Migration[7.2]
class AddCoverAndProfilePictureToArtists < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :cover, :string
    add_column :artists, :profile_picture, :string
  end
end
