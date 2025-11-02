class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.text :bio
      t.string :phone
      t.string :website
      t.string :profile_picture
      t.string :cover_image
      t.string :facebook_url
      t.string :twitter_url
      t.string :instagram_url
      t.string :linkedin_url
      t.string :youtube_url
      t.string :spotify_url
      t.string :soundcloud_url
      t.string :pinterest_url
      t.string :tiktok_url
      t.text :specialization
      t.text :experience
      t.string :location
      t.boolean :public_profile, default: true

      t.timestamps
    end
  end
end
