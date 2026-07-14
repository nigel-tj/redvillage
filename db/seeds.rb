# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Clear existing users if reseeding (optional - comment out if you want to keep existing users)
puts "Seeding demo users and roles..."

# Demo password for local demo users.
# In production, ALWAYS supply DEMO_SEED_PASSWORD via ENV and rotate immediately
# after first deploy — never ship a known password.
DEMO_PASSWORD = ENV.fetch("DEMO_SEED_PASSWORD") { "password123" }

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
  role_name = role.is_a?(Integer) ? (User.roles.key(role)&.to_s&.humanize || "role(#{role})") : role.to_s.humanize
  puts "  #{role_name}: #{count}"
end

puts "\n✓ Seed data created successfully!"

# ============================================================
# DEMO CONTENT (mall / store / product / event)
# ============================================================
puts "\n=== Creating Demo Mall / Store / Product / Event ==="

demo_user = User.find_by(email: "member@redvillage.test") || User.first
raise "Seed aborted: no user available to own demo store" unless demo_user

mall = Mall.find_or_create_by!(name: "Red Village Creative Mall") do |m|
  m.contact_email = "mall@redvillage.test"
end
puts "  ✓ Mall: #{mall.name}"

store = Store.find_or_initialize_by(name: "Artisan Corner")
store.assign_attributes(
  email: "artisan@redvillage.test",
  description: "Handcrafted goods from Zimbabwean makers — art, decor, and apparel.",
  user: demo_user,
  mall: mall
)
store.save!
store.build_storefront_settings(primary_color: "#a83232", accent_color: "#f0a500") unless store.storefront_settings
store.save!
puts "  ✓ Store: #{store.name} (owned by #{demo_user.email}, mall: #{mall.name})"

products = [
  { name: "Handwoven Wall Basket", price: 29.99, inventory_quantity: 25, sku: "AC-BSK-001", description: "Natural fibre wall basket, woven by rural artisans." },
  { name: "Painted Gourd Lamp", price: 45.00, inventory_quantity: 12, sku: "AC-LMP-002", description: "Upcycled gourd lamp with hand-painted motifs." },
  { name: "Shona Stone Sculpture", price: 89.50, inventory_quantity: 6, sku: "AC-SCL-003", description: "Authentic Shona-style soapstone sculpture." }
]
products.each do |attrs|
  product = store.products.find_or_initialize_by(name: attrs[:name])
  product.assign_attributes(attrs)
  product.save!
  puts "    ✓ Product: #{product.name} ($#{product.price})"
end

event = Event.find_or_initialize_by(name: "Red Village Creative Festival 2026")
event.assign_attributes(
  date: Date.new(2026, 9, 19),
  start_time: "10:00",
  venue: "Harare Exhibition Park",
  summary: "A celebration of Zimbabwean music, art, and maker culture.",
  standard_ticket_price: 15.00,
  vip_ticket_price: 50.00,
  currency: "USD",
  featured: true
)
event.save!
puts "  ✓ Event: #{event.name}"

# --- Demo Artists (populate /artists marketplace page) ---
Artist.find_or_initialize_by(name: "Takudzwa Moyo").tap do |a|
  a.assign_attributes(email: "takudzwa@redvillage.test", category: "Sculpture")
  a.save!
end
Artist.find_or_initialize_by(name: "Nyasha Chikowero").tap do |a|
  a.assign_attributes(email: "nyasha@redvillage.test", category: "Painting")
  a.save!
end
puts "  ✓ Artists: #{Artist.count} demo artist profiles"

# Give the artist-role demo users a Profile so they surface on /artists
[artist1, artist2].compact.each do |u|
  next if u.profile.present?
  u.build_profile(name: u.name).save!
end
puts "  ✓ Artist-user profiles created: #{Profile.joins(:user).where(users: { role: :artist }).count}"

# --- Demo Music (populate /music marketplace page) ---
album = Album.find_or_initialize_by(name: "Red Village Sessions Vol. 1")
album.assign_attributes(artist_name: "Various Artists")
album.save!
puts "  ✓ Album: #{album.name}"

track = Track.find_or_initialize_by(title: "Harare Nights")
track.assign_attributes(
  category: "rcv_playlist",
  artist_name: "Takudzwa Moyo",
  album: album,
  intro: "A mellow groove recorded live in Harare."
)
track.save!
puts "  ✓ Track: #{track.title}"

puts "\n=== Demo Content Summary ==="
puts "  Malls: #{Mall.count} | Stores: #{Store.count} | Products: #{Product.count} | Events: #{Event.count} | Artists: #{Artist.count} | Albums: #{Album.count} | Tracks: #{Track.count}"

