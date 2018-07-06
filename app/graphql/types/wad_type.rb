Types::WadType = GraphQL::ObjectType.define do
  name 'Wad'

  field :id,            !types.Int
  field :username,      !types.String
  field :name,          !types.String
  field :author,        types.String
  field :year,          types.String
  field :compatibility, types.String
  field :is_commercial, types.Boolean
  field :versions,      types.Int
  field :single_map,    types.Boolean

  field :demo_count, !types.Int
  field :player_count, !types.Int

  field :longest_demo_time, !types.String
  field :total_demo_time,   !types.String
  field :average_demo_time, !types.String

  field :most_recorded_player, !types.String

  field :record, Types::DemoType do
    argument :level,    !types.String
    argument :category, !types.String
    argument :guys,      types.Int, default_value: 1
    argument :tas,       types.Int, default_value: 0

    resolve -> (obj, args, _ctx) do
      obj.record(args[:level], args[:category], args[:guys], args[:tas])
    end
  end

  field :run_demos, types[Types::DemoType] do
    argument :level,    !types.String
    argument :category, !types.String
    argument :guys,      types.Int, default_value: 1
    argument :tas,       types.Int, default_value: 0

    resolve -> (obj, args, _ctx) do
      obj.run_demos(args[:level], args[:category], args[:guys], args[:tas])
    end
  end

  field :iwad, !Types::IwadType
end
