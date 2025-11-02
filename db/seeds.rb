# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Clear existing users if reseeding (optional - comment out if you want to keep existing users)
puts "Seeding demo users and roles..."

# Demo password for all test users
DEMO_PASSWORD = "password123"

# Helper method to create or update users
def create_demo_user(email, name, role, attributes = {})
  user = User.find_or_initialize_by(email: email)
  user.assign_attributes(
    name: name,
    role: role,
    password: DEMO_PASSWORD,
    password_confirmation: DEMO_PASSWORD
  )
  user.assign_attributes(attributes) if attributes.present?
  user.save!
  puts "  ✓ Created #{role} user: #{name} (#{email})"
  user
rescue => e
  puts "  ✗ Failed to create #{role} user #{name}: #{e.message}"
  nil
end

puts "\n=== Creating Admin Users ==="
admin1 = create_demo_user(
  "admin@redvillage.test",
  "Admin User",
  :admin
)

admin2 = create_demo_user(
  "superadmin@redvillage.test",
  "Super Admin",
  :admin
)

puts "\n=== Creating DJ Users ==="
dj1 = create_demo_user(
  "dj@redvillage.test",
  "DJ MixMaster",
  :dj
)

dj2 = create_demo_user(
  "dj2@redvillage.test",
  "DJ SpinRush",
  :dj
)

puts "\n=== Creating Artist Users ==="
artist1 = create_demo_user(
  "artist@redvillage.test",
  "The Sound Artist",
  :artist
)

artist2 = create_demo_user(
  "artist2@redvillage.test",
  "Music Creator",
  :artist
)

puts "\n=== Creating Photographer Users ==="
photographer1 = create_demo_user(
  "photographer@redvillage.test",
  "Photo Snapper",
  :photographer
)

photographer2 = create_demo_user(
  "photographer2@redvillage.test",
  "Lens Master",
  :photographer
)

puts "\n=== Creating Videographer Users ==="
videographer1 = create_demo_user(
  "videographer@redvillage.test",
  "Video Producer",
  :videographer
)

videographer2 = create_demo_user(
  "videographer2@redvillage.test",
  "Cinema Director",
  :videographer
)

puts "\n=== Creating Curator Users ==="
curator1 = create_demo_user(
  "curator@redvillage.test",
  "Content Curator",
  :curator
)

curator2 = create_demo_user(
  "curator2@redvillage.test",
  "Art Curator",
  :curator
)

puts "\n=== Creating Designer Users ==="
designer1 = create_demo_user(
  "designer@redvillage.test",
  "Visual Designer",
  :designer
)

designer2 = create_demo_user(
  "designer2@redvillage.test",
  "Creative Designer",
  :designer
)

puts "\n=== Creating Editor Users ==="
editor1 = create_demo_user(
  "editor@redvillage.test",
  "Content Editor",
  :editor
)

editor2 = create_demo_user(
  "editor2@redvillage.test",
  "Media Editor",
  :editor
)

puts "\n=== Creating Regular Member Users ==="
member1 = create_demo_user(
  "member@redvillage.test",
  "Regular Member",
  :member
)

member2 = create_demo_user(
  "member2@redvillage.test",
  "Community Member",
  :member
)

member3 = create_demo_user(
  "member3@redvillage.test",
  "Guest User",
  :member
)

puts "\n=== Seed Summary ==="
puts "Total users created: #{User.count}"
puts "\nUsers by role:"
User.group(:role).count.each do |role, count|
  role_name = User.roles.key(role).humanize
  puts "  #{role_name}: #{count}"
end

puts "\n=== Demo Login Credentials ==="
puts "All demo users use password: #{DEMO_PASSWORD}"
puts "\nAdmin accounts:"
puts "  - admin@redvillage.test / #{DEMO_PASSWORD}"
puts "  - superadmin@redvillage.test / #{DEMO_PASSWORD}"
puts "\nBackstage users (can access admin area):"
puts "  - DJ: dj@redvillage.test / #{DEMO_PASSWORD}"
puts "  - Artist: artist@redvillage.test / #{DEMO_PASSWORD}"
puts "  - Photographer: photographer@redvillage.test / #{DEMO_PASSWORD}"
puts "  - Videographer: videographer@redvillage.test / #{DEMO_PASSWORD}"
puts "  - Curator: curator@redvillage.test / #{DEMO_PASSWORD}"
puts "  - Designer: designer@redvillage.test / #{DEMO_PASSWORD}"
puts "  - Editor: editor@redvillage.test / #{DEMO_PASSWORD}"
puts "\nRegular members:"
puts "  - member@redvillage.test / #{DEMO_PASSWORD}"

puts "\n✓ Seed data created successfully!"
