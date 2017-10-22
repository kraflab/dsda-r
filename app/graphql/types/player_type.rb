Types::PlayerType = GraphQL::ObjectType.define do
  name 'Player'

  field :id,       !types.Int
  field :username, !types.String
  field :name,     !types.String

  field :twitch_url,  types.String
  field :youtube_url, types.String

  field :demo_count,         !types.Int
  field :average_demo_count, !types.Int, 'Average demos recorded per wad.'
  field :wad_count,  !types.Int, 'The number of wads recorded on.'
  field :tas_count,  !types.Int, 'The number of tas demos recorded.'

  field :longest_demo_time, !types.String
  field :average_demo_time, !types.String
  field :total_demo_time,   !types.String

  field :most_recorded_wad,      !types.String
  field :most_recorded_category, !types.String
end
