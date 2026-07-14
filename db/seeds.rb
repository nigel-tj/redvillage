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
  a.assign_attributes(
    email: "takudzwa@redvillage.test",
    category: "Sculpture",
    bio: "Takudzwa Moyo is a Harare-based sculptor working in springstone and recycled metal. " \
         "His pieces explore the tension between tradition and modern Zimbabwean life, and have " \
         "been exhibited at the National Gallery and several regional art fairs."
  )
  a.save!
end
Artist.find_or_initialize_by(name: "Nyasha Chikowero").tap do |a|
  a.assign_attributes(
    email: "nyasha@redvillage.test",
    category: "Painting",
    bio: "Nyasha Chikowero paints vibrant acrylic landscapes and portraits inspired by everyday " \
         "life in Zimbabwe. A self-taught artist, she runs community workshops for young painters " \
         "and sells her work through Artisan Corner on Red Village."
  )
  a.save!
end
puts "  ✓ Artists: #{Artist.count} demo artist profiles"

# Give the artist-role demo users a Profile so they surface on /artists
artist_bios = {
  artist1 => "The Sound Artist is a producer and DJ crafting Afro-house and amapiano sets for the " \
             "Red Village Creative Festival stage. When not in the studio, he mentors up-and-coming " \
             "beatmakers from Harare.",
  artist2 => "Music Creator is a singer-songwriter and multi-instrumentalist blending Shona melodies " \
             "with contemporary R&B. Her debut EP was recorded entirely at home during the 2025 lockdown."
}
[artist1, artist2].compact.each do |u|
  profile = u.profile || u.build_profile(name: u.name)
  profile.assign_attributes(
    bio: artist_bios[u] || "Creative member of the Red Village community.",
    location: "Harare, Zimbabwe",
    public_profile: true,
    website: "https://redvillage.test/#{u.name.parameterize}"
  )
  profile.save!
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

# ============================================================
# RICH REALISTIC DATASET (expanded marketplace content)
# ============================================================
puts "\n=== Expanding marketplace dataset ==="

# --- Additional Mall ---
mall2 = Mall.find_or_create_by!(name: "Mbare Arts Market Online") do |m|
  m.contact_email = "mbare@redvillage.test"
end
puts "  ✓ Mall: #{mall2.name}"

# --- Additional Stores (owned by existing demo users) ---
extra_stores = [
  { name: "Studio Zolile", owner: designer1, email: "zolile@redvillage.test",
    description: "Bold screenprints and illustrative art by Visual Designer Zolile.",
    primary: "#1d4ed8", accent: "#f59e0b" },
  { name: "Lens & Light Photography", owner: photographer1, email: "lenslight@redvillage.test",
    description: "Fine-art photographic prints of Harare life by Photo Snapper.",
    primary: "#0f766e", accent: "#fcd34d" },
  { name: "Clay & Co Ceramics", owner: designer2, email: "clayco@redvillage.test",
    description: "Hand-thrown stoneware and glazed ceramics by Creative Designer.",
    primary: "#9a3412", accent: "#fdba74" },
  { name: "Weaving Women Co-op", owner: member2, email: "weaving@redvillage.test",
    description: "Sisal baskets, placemats and wool throws made by a Harare women's cooperative.",
    primary: "#7c3aed", accent: "#a7f3d0" },
  { name: "Mbare Beats Records", owner: artist1, email: "beats@redvillage.test",
    description: "Vinyl, tees and workshops from The Sound Artist.",
    primary: "#be123c", accent: "#fda4af" }
]
extra_stores.each do |s|
  st = Store.find_or_initialize_by(name: s[:name])
  st.assign_attributes(email: s[:email], description: s[:description], user: s[:owner], mall: mall)
  st.save!
  st.build_storefront_settings(primary_color: s[:primary], accent_color: s[:accent]) unless st.storefront_settings
  st.save!
  puts "  ✓ Store: #{st.name} (owned by #{s[:owner].email})"
end

# --- More products across stores ---
product_catalog = {
  "Artisan Corner" => [
    { name: "Kitenge Print Cushion", price: 24.00, inventory_quantity: 40, sku: "AC-CSH-004", description: "Vibrant kitenge fabric cushion cover, 45cm square." },
    { name: "Beehive Storage Basket", price: 19.99, inventory_quantity: 30, sku: "AC-BSK-005", description: "Coiled beehive basket, natural fibres." },
    { name: "Carved Wooden Mask", price: 54.00, inventory_quantity: 8, sku: "AC-MSK-006", description: "Hand-carved ceremonial mask by a Mutare carver." }
  ],
  "Studio Zolile" => [
    { name: "Mbira Dreams Art Print", price: 35.00, inventory_quantity: 50, sku: "SZ-PRT-001", description: "A3 giclée print, signed." },
    { name: "Harare Skyline Print", price: 40.00, inventory_quantity: 50, sku: "SZ-PRT-002", description: "Limited-edition cityscape print." },
    { name: "Custom Logo Design", price: 60.00, inventory_quantity: 999, sku: "SZ-DSG-003", description: "Bespoke brand identity, delivered digitally." }
  ],
  "Lens & Light Photography" => [
    { name: "Mbare Morning Print", price: 30.00, inventory_quantity: 25, sku: "LL-PRT-001", description: "A3 B&W photograph of a Mbare dawn." },
    { name: "Street Vendor Print", price: 28.00, inventory_quantity: 25, sku: "LL-PRT-002", description: "Candid street photograph, framed." },
    { name: "Portrait Session Voucher", price: 120.00, inventory_quantity: 20, sku: "LL-VCH-003", description: "One-hour studio portrait session in Harare." }
  ],
  "Clay & Co Ceramics" => [
    { name: "Hand-thrown Mug", price: 18.00, inventory_quantity: 60, sku: "CC-MUG-001", description: "Speckled stoneware mug, 300ml." },
    { name: "Glazed Serving Bowl", price: 45.00, inventory_quantity: 20, sku: "CC-BWL-002", description: "Reactive-glaze serving bowl, 28cm." },
    { name: "Ceramic Planter", price: 22.00, inventory_quantity: 35, sku: "CC-PLT-003", description: "Minimalist planter with drainage tray." }
  ],
  "Weaving Women Co-op" => [
    { name: "Sisal Placemat Set", price: 26.00, inventory_quantity: 45, sku: "WW-PMT-001", description: "Set of 4 handwoven sisal placemats." },
    { name: "Telephone Wire Basket", price: 33.00, inventory_quantity: 30, sku: "WW-BSK-002", description: "Colourful woven telephone-wire basket." },
    { name: "Wool Throw", price: 75.00, inventory_quantity: 15, sku: "WW-THR-003", description: "Hand-loomed wool throw, 130x180cm." }
  ],
  "Mbare Beats Records" => [
    { name: "Harare Nights Vinyl", price: 25.00, inventory_quantity: 100, sku: "MB-VNL-001", description: "Limited pressing of the Harare Nights single." },
    { name: "Artist Tee", price: 20.00, inventory_quantity: 80, sku: "MB-TEE-002", description: "Cotton tee with The Sound Artist artwork." },
    { name: "Beatmaking Workshop", price: 50.00, inventory_quantity: 40, sku: "MB-WSH-003", description: "Two-hour intro to producing amapiano." }
  ]
}
product_catalog.each do |store_name, items|
  st = Store.find_by(name: store_name)
  next unless st
  items.each do |attrs|
    p = st.products.find_or_initialize_by(name: attrs[:name])
    p.assign_attributes(attrs.merge(status: "active"))
    p.save!
    puts "    ✓ Product: #{p.name} ($#{p.price})"
  end
end

# --- More Events ---
extra_events = [
  { name: "Harare Jazz & Poetry Night", date: Date.new(2026, 8, 15), start_time: "19:00",
    venue: "Book Café, Harare", summary: "An intimate evening of jazz and spoken word.",
    standard: 10.00, vip: 30.00 },
  { name: "Mbare Makers Christmas Market", date: Date.new(2026, 12, 5), start_time: "09:00",
    venue: "Mbare Art Centre, Harare", summary: "A festive market of local makers and food.",
    standard: 5.00, vip: 15.00 }
]
extra_events.each do |e|
  ev = Event.find_or_initialize_by(name: e[:name])
  ev.assign_attributes(date: e[:date], start_time: e[:start_time], venue: e[:venue],
                       summary: e[:summary], standard_ticket_price: e[:standard],
                       vip_ticket_price: e[:vip], currency: "USD", featured: false)
  ev.save!
  puts "  ✓ Event: #{ev.name}"
end

# --- More Artists (Artist model records for /artists directory) ---
extra_artists = [
  { name: "Farai Mutasa", category: "Photography", email: "farai@redvillage.test",
    bio: "Farai Mutasa documents everyday Harare through street and documentary photography, with work shown at the Zimbabwe International Film Festival." },
  { name: "Chiedza Mupfudza", category: "Textile Art", email: "chiedza@redvillage.test",
    bio: "Chiedza Mupfudza creates large-scale textile installations using recycled kitenge, exploring identity and memory." },
  { name: "Tatenda Mapfumo", category: "Music", email: "tatenda@redvillage.test",
    bio: "Tatenda Mapfumo is a mbira virtuoso and composer fusing traditional Shona music with electronic production." },
  { name: "Rumbidzai Choto", category: "Ceramics", email: "rumbidzai@redvillage.test",
    bio: "Rumbidzai Choto throws functional stoneware inspired by Zimbabwean flora, running classes from her Harare studio." }
]
extra_artists.each do |a|
  art = Artist.find_or_initialize_by(name: a[:name])
  art.assign_attributes(email: a[:email], category: a[:category], bio: a[:bio])
  art.save!
  puts "  ✓ Artist: #{art.name} (#{art.category})"
end

# --- Public profiles for more creator-role users (populates /creators listings) ---
creator_profiles = {
  photographer1 => "Photo Snapper is a Harare-based photographer specialising in events and portraiture, with a decade behind the lens.",
  videographer1 => "Video Producer tells brand and music stories through film, with credits on several local music videos.",
  designer1     => "Visual Designer Zolile builds bold visual identities for Zimbabwean startups and artists.",
  curator1      => "Content Curator shapes the Red Village editorial voice, championing emerging makers."
}
creator_profiles.each do |u, bio|
  profile = u.profile || u.build_profile(name: u.name)
  profile.assign_attributes(bio: bio, location: "Harare, Zimbabwe", public_profile: true,
                            website: "https://redvillage.test/#{u.name.parameterize}")
  profile.save!
  puts "  ✓ Profile: #{profile.display_name}"
end

# --- Second Album + more Tracks ---
album2 = Album.find_or_initialize_by(name: "Mbira Echoes")
album2.assign_attributes(artist_name: "Tatenda Mapfumo")
album2.save!
puts "  ✓ Album: #{album2.name}"

extra_tracks = [
  { title: "Mbira Dreams", artist_name: "Tatenda Mapfumo", album: album2, category: "rcv_playlist", intro: "A meditative mbira-led groove." },
  { title: "Dzimbahwe", artist_name: "Tatenda Mapfumo", album: album2, category: "rcv_playlist", intro: "Pride anthem blending Shona vocals." },
  { title: "Skyline", artist_name: "The Sound Artist", album: album, category: "rcv_playlist", intro: "Late-night city pulse." },
  { title: "River Song", artist_name: "Music Creator", album: album, category: "rcv_playlist", intro: "Acoustic reflection." },
  { title: "Midnight Train", artist_name: "The Sound Artist", album: album, category: "rcv_playlist", intro: "Amapiano-infused instrumental." }
]
extra_tracks.each do |t|
  tr = Track.find_or_initialize_by(title: t[:title])
  tr.assign_attributes(artist_name: t[:artist_name], album: t[:album], category: t[:category], intro: t[:intro])
  tr.save!
  puts "    ✓ Track: #{tr.title}"
end

# --- Galleries + Images (art sections; attachments left nil, views guard) ---
galleries = [
  { name: "Contemporary Zimbabwean Painting", category: "Painting",
    images: ["Harare Market Scene", "Mother and Child", "Urban Rhythm"] },
  { name: "Springstone Sculpture", category: "Sculpture",
    images: ["Family Unity", "The Thinker", "Spirit of the Land"] },
  { name: "Harare Street Photography", category: "Photography",
    images: ["Commuter Rush", "Corner Café", "Evening Trade"] }
]
galleries.each do |g|
  gal = Gallery.find_or_create_by!(name: g[:name]) do |x|
    x.category = g[:category]
  end
  g[:images].each do |img_name|
    img = gal.images.find_or_initialize_by(name: img_name)
    img.save! if img.new_record?
  end
  puts "  ✓ Gallery: #{gal.name} (#{gal.images.count} images)"
end

# --- Videos (real YouTube embed URLs; format-validated) ---
videos = [
  { title: "Red Village Festival Reel", link: "https://www.youtube.com/watch?v=jNQXAC9IVRw", category: "festival" },
  { title: "Weaving a Sisal Basket", link: "https://www.youtube.com/watch?v=60ItHLz5WEA", category: "craft" },
  { title: "Mbira Performance", link: "https://www.youtube.com/watch?v=kJQP7kiw5Fk", category: "music" },
  { title: "Harare Studio Tour", link: "https://www.youtube.com/watch?v=9bZkp7q19f0", category: "behind-the-scenes" }
]
videos.each do |v|
  vid = Video.find_or_initialize_by(title: v[:title])
  vid.assign_attributes(link: v[:link], category: v[:category], published_at: Time.now)
  vid.save!
  puts "  ✓ Video: #{vid.title}"
end

# --- Features / News (blog) ---
features = [
  { heading: "Red Village Festival returns bigger in 2026",
    intro: "Three stages, fifty makers and a night market — here's what to expect at this year's festival.",
    link: "/events", thumb: "Festival crowds under string lights" },
  { heading: "Meet the weavers of Mbare",
    intro: "How a women's cooperative turned sisal weaving into a thriving creative business.",
    link: "/stores", thumb: "Hands weaving a basket" },
  { heading: "How Zimbabwean sculpture found the world",
    intro: "From roadside workshops to international galleries, the springstone story.",
    link: "/artists", thumb: "Polished stone sculpture" },
  { heading: "Opening a store on Red Village: a guide",
    intro: "Everything a maker needs to set up their first online storefront.",
    link: "/stores", thumb: "Laptop on a studio desk" }
]
features.each do |f|
  feat = Feature.find_or_initialize_by(heading: f[:heading])
  feat.assign_attributes(intro: f[:intro], link: f[:link], thumb: f[:thumb])
  feat.save!
  puts "  ✓ Feature: #{feat.heading}"
end

# --- Lifestyles (editorial) ---
lifestyles = [
  { title: "Decorating with African textiles", category: "fashion", intro: "Five ways to style kitenge and sisal in a modern home.", link: "/stores" },
  { title: "Starting your creative side-hustle", category: "healthyLiving", intro: "From hobby to income: a practical roadmap for makers.", link: "/stores" },
  { title: "Photographing Harare like a local", category: "fashion", intro: "A walking route for capturing the city's character.", link: "/gallery" }
]
lifestyles.each do |l|
  ls = Lifestyle.find_or_initialize_by(title: l[:title])
  ls.assign_attributes(category: l[:category], intro: l[:intro], link: l[:link])
  ls.save!
  puts "  ✓ Lifestyle: #{ls.title}"
end

puts "\n=== Updated Demo Content Summary ==="
puts "  Malls: #{Mall.count} | Stores: #{Store.count} | Products: #{Product.count} | Events: #{Event.count}"
puts "  Artists: #{Artist.count} | Albums: #{Album.count} | Tracks: #{Track.count}"
puts "  Galleries: #{Gallery.count} | Images: #{Image.count} | Videos: #{Video.count} | Features: #{Feature.count} | Lifestyles: #{Lifestyle.count}"

