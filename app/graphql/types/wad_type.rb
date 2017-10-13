Types::WadType = GraphQL::ObjectType.define do
  name 'Wad'

  field :id,       !types.Int
  field :username, !types.String
  field :name,     !types.String

  field :iwad, Types::IwadType do
    resolve -> (obj, args, ctx) { obj.iwad }
  end
end
