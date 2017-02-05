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