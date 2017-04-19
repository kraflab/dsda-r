case Rails.env
when "development"
  Admin.create!(username: "kraflab", password: "password1234", fail_count: 0)
when "production"
  Admin.create!(username: "kraflab", password: ENV["SECRET_ADMIN_PASS"], fail_count: 0)
end

Iwad.create!(name: "Doom", username: "doom", author: "id Software")
Iwad.create!(name: "Doom II", username: "doom2", author: "id Software")
Iwad.create!(name: "Hexen", username: "hexen", author: "Raven Software")

# Heretic-N
heretic = Iwad.create!(name: "Heretic", username: "heretic", author: "Raven Software")
heretic.wads.create!(name: "Heretic", username: "heretic", author: "Raven Software", file: "")
[
  'Andrey Boldt', 'Laurent Sebellin', 'JC', 'William Huber', 'Vincent Catalaa',
  'Hitherto', 'QWERTY', 'Radek Pecka', 'Xit Vono', 'Drew DeVore', 'Kimo Xvirus',
  'Bruno Vergílio', 'Arno Slagboom', 'Branimir H. Beric', 'Jeff Easthope',
  'Lucas Marincak', 'Doug Merrill', 'Jeff N. Easthope', 'PVS', 'Mikhail Volkov',
  'Ch0wW', 'Suicider', 'Oxyde'
].each do |name|
  Player.create!(name: name, username: Player.default_username(name))
end

Category.create!(name: "UV Speed",    description: "Exit as fast as possible on skill 4.")
Category.create!(name: "SM Speed",    description: "Exit as fast as possible on skill 4 (heretic).")
Category.create!(name: "UV Max",      description: "Exit with all monsters dead (except lost souls) and all secrets collected on skill 4.")
Category.create!(name: "SM Max",      description: "Exit with all monsters dead (except lost souls) and all secrets collected on skill 4 (heretic).")
Category.create!(name: "Tyson",       description: "Exit with all monsters dead (except lost souls) on skill 4, using only weapons 1 and 2 (fist, chainsaw, pistol).")
Category.create!(name: "UV Fast",     description: "Exit with all monsters dead (except lost souls) and all secrets collected on skill 4, using the -fast parameter.")
Category.create!(name: "BP Max",      description: "Exit with all monsters dead (except lost souls) and all secrets collected on skill 5 (heretic).")
Category.create!(name: "UV Respawn",  description: "Exit with 100% Kills and all secrets collected on skill 4, using the -respawn parameter.")
Category.create!(name: "BP Speed",    description: "Exit as fast as possible on skill 5 (heretic).")
Category.create!(name: "NM Speed",    description: "Exit as fast as possible on skill 5.")
Category.create!(name: "NM 100S",     description: "Exit with all secrets collected on skill 5.")
Category.create!(name: "Pacifist",    description: "Exit as fast as possible on skill 4, without hurting monsters either directly or indirectly (no barrels, crushers, telefrags).")
Category.create!(name: "Stroller",    description: "Pacifist, using the -turbo 50 parameter, without strafing.")
Category.create!(name: "NoMo",        description: "Exit as fast as possible, using the -nomonsters parameter.")
Category.create!(name: "NoMo 100S",   description: "Exit with all secrets collected, using the -nomonsters parameter.")
Category.create!(name: "Collector",   description: "Exit with all weapons picked up, using the -nomonsters parameter.")
Category.create!(name: "Other",       description: "Nonstandard category or movie.")
Category.create!(name: "FDA",         description: "First demo attempt: play a map until you exit.")

if Rails.env.development?
  50.times do
    name     = Faker::Name.name
    username = Faker::Internet.unique.user_name(nil, %w(_))
    twitch   = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
    youtube  = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
    
    Player.create!(name: name, username: username, twitch: twitch,
                                                   youtube: youtube)
  end
  
  doom = Iwad.first
  50.times do
    name     = Faker::App.unique.name
    username = name.gsub(/\s+/, '').slice(0, 8).downcase
    author   = Faker::Name.name
    doom.wads.create!(name: name, username: username, author: author, file: "")
  end
  
  Port.create!(family: "PRBoom+", version: "v2.5.1.4")
  Port.create!(family: "GZDoom",  version: "v2.0.05")
  Port.create!(family: "CNDoom",  version: "v2.0.3.2")
  Port.create!(family: "PRBoom+", version: "v2.5.1.5")
  
  player = Player.first
  90.times do
    cat  = Category.order("RANDOM()").first
    wad  = Wad.first #reorder("RANDOM()").first
    tics = rand(100000) + 1
    is_tas = rand(100) < 10
    is_coop = rand(100) < 10
    demo = Demo.create!(tics:        tics,
                        has_tics:    true,
                        level:       "Map #{(rand(32) + 1).to_s.rjust(2, '0')}",
                        levelstat:   Demo.tics_to_string(tics),
                        tas:         is_tas ? 1 : 0,
                        guys:        is_coop ? 2 : 1,
                        recorded_at: rand(100).days.ago,
                        created_at:  rand(100).days.ago,
                        wad:         wad,
                        category:    cat,
                        engine:      "PRBoom+ v2.5.1.4 cl9")
    player.player_demos.create(demo: demo)
  end
  
  tics = [12340, 8440, 7420, 6032, 5987, 4609, 3295, 3000, 2950, 1546]
  tics.each_with_index do |tic, n|
    @recorded_at ||= 30.days.ago
    @recorded_at += (1 + rand()).days
    demo = Demo.create!(tics: tic,
                        has_tics: true,
                        level: "Map 01",
                        levelstat: Demo.tics_to_string(tic),
                        tas: 0,
                        guys: 1,
                        recorded_at: @recorded_at,
                        wad: Wad.first,
                        category: Category.first,
                        engine: "PRBoom+ v2.5.1.4 cl9")
    player.player_demos.create(demo: demo)
  end
  
  subcategory = SubCategory.create!(name: "Also reality", show: true)
  
  Tag.create!(sub_category: subcategory, demo: Demo.second)
end
