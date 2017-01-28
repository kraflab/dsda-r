50.times do
  name     = Faker::Name.name
  username = Faker::Internet.unique.user_name(nil, %w(_))
  twitch   = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
  youtube  = Faker::Boolean.boolean ? Faker::Internet.user_name(nil, %w(_)) : ""
  
  Player.create!(name: name, username: username, twitch: twitch,
                                                 youtube: youtube)
end

Admin.create!(username: "kraflab", password: "password1234")
