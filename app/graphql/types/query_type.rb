require_relative '../graphql_helpers'

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :player, Types::PlayerType do
    description 'Retrieves player with a given ID, username, or name.'

    argument :id, types.ID
    argument :username, types.String
    argument :name, types.String

    resolve -> (_obj, args, _ctx) {
      find_by_one_of! :id, :username, :name, args, Player
    }
  end

  field :players, !types[Types::PlayerType] do
    resolve -> (obj, args, ctx) {
      Player.all
    }
  end

  field :iwad, Types::IwadType do
    description 'Retrieves iwad with a given ID, username, or name.'

    argument :id, types.ID
    argument :username, types.String
    argument :name, types.String

    resolve -> (_obj, args, _ctx) {
      find_by_one_of! :id, :username, :name, args, Iwad
    }
  end

  field :iwads, !types[Types::IwadType] do
    resolve -> (obj, args, ctx) {
      Iwad.all
    }
  end

  field :wad, Types::WadType do
    description 'Retrieves wad with a given ID, username, or name.'

    argument :id, types.ID
    argument :username, types.String
    argument :name, types.String

    resolve -> (_obj, args, _ctx) {
      find_by_one_of! :id, :username, :name, args, Wad
    }
  end

  field :wads, !types[Types::WadType] do
    resolve -> (obj, args, ctx) {
      Wad.all
    }
  end
end
