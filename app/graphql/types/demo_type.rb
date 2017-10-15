Types::DemoType = GraphQL::ObjectType.define do
  name 'Demo'

  field :id,    !types.Int
  field :level, !types.String
  field :tas,   !types.Int
  field :tics,  !types.Int
  field :guys,  !types.Int, 'Number of in-game players'
  field :recorded_at, types.String
  field :levelstat, types.String
  field :has_tics, types.Boolean
  field :engine, types.String
  field :version, types.Int
  field :compatibility, types.Int

  field :players, !types[Types::PlayerType]
  field :category_name, !types.String
  field :time, !types.String
  field :video_url, types.String
  field :file_path, types.String
  field :record_index, !types.Int, 'Number of slower runs, if a record'
end
