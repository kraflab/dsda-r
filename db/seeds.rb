50.times do
  name     = Faker::Name.name
  username = Faker::Internet.unique.user_name(nil, %w(_))
  twitch   = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
  youtube  = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
  
  Player.create!(name: name, username: username, twitch: twitch,
                                                 youtube: youtube)
end

Iwad.create!(name: "Doom", username: "doom", author: "id Software")
Iwad.create!(name: "Doom II", username: "doom2", author: "id Software")
Iwad.create!(name: "Heretic", username: "heretic", author: "Raven Software")
Iwad.create!(name: "Hexen", username: "hexen", author: "Raven Software")

Admin.create!(username: "kraflab", password: "password1234")
