class AddSlugToArtistsAndProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :slug, :string
    add_index :artists, :slug, unique: true

    add_column :profiles, :slug, :string
    add_index :profiles, :slug, unique: true
  end
end
