class AddDjAndArtistRolesToUsers < ActiveRecord::Migration[7.2]
  # Note: No database changes needed as role is already an integer enum
  # The new roles (dj: 2, artist: 3) are defined in the User model enum
  # This migration is kept for documentation purposes
  
  def change
    # The role column already exists as integer
    # Enum values are defined in app/models/user.rb:
    # member: 0, admin: 1, dj: 2, artist: 3
  end
end
