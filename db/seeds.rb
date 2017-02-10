50.times do
  name     = Faker::Name.name
  username = Faker::Internet.unique.user_name(nil, %w(_))
  twitch   = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
  youtube  = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
  
  Player.create!(name: name, username: username, twitch: twitch,
                                                 youtube: youtube)
end

doom = Iwad.create!(name: "Doom", username: "doom", author: "id Software")
Iwad.create!(name: "Doom II", username: "doom2", author: "id Software")
Iwad.create!(name: "Heretic", username: "heretic", author: "Raven Software")
Iwad.create!(name: "Hexen", username: "hexen", author: "Raven Software")

50.times do
  name     = Faker::App.unique.name
  username = name.gsub(/\s+/, '').slice(0, 8).downcase
  author   = Faker::Name.name
  doom.wads.create!(name: name, username: username, author: author, file: "")
end

Admin.create!(username: "kraflab", password: "password1234")

Port.create!(family: "PRBoom+", version: "v2.5.1.4")
Port.create!(family: "GZDoom",  version: "v2.0.05")
Port.create!(family: "CNDoom",  version: "v2.0.3.2")
Port.create!(family: "PRBoom+", version: "v2.5.1.5")

Category.create!(name: "UV Speed",    description: "Exit as fast as possible on skill 4.")
Category.create!(name: "UV Max",      description: "Exit with all monsters dead (except lost souls) and all secrets collected on skill 4.")
Category.create!(name: "UV Tyson",    description: "Exit with all monsters dead (except lost souls) on skill 4, using only weapons 1 and 2 (fist, chainsaw, pistol).")
Category.create!(name: "UV Fast",     description: "Exit with all monsters dead (except lost souls) and all secrets collected on skill 4, using the -fast parameter.")
Category.create!(name: "UV Respawn",  description: "Exit with 100% Kills and all secrets collected on skill 4, using the -respawn parameter.")
Category.create!(name: "NM Speed",    description: "Exit as fast as possible on skill 5.")
Category.create!(name: "NM 100S",     description: "Exit with all secrets collected on skill 5.")
Category.create!(name: "UV Pacifist", description: "Exit as fast as possible on skill 4, without hurting monsters either directly or indirectly (no barrels, crushers, telefrags).")
Category.create!(name: "Stroller",    description: "UV Pacifist, using the -turbo 50 parameter, without strafing.")
Category.create!(name: "NoMo",        description: "Exit as fast as possible, using the -nomonsters parameter.")
Category.create!(name: "NoMo 100S",   description: "Exit with all secrets collected, using the -nomonsters parameter.")
Category.create!(name: "Collector",   description: "Exit with all weapons picked up, using the -nomonsters parameter.")
Category.create!(name: "Other",       description: "Nonstandard category or movie.")
