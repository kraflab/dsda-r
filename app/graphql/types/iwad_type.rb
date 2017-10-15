Types::IwadType = GraphQL::ObjectType.define do
  name 'Iwad'

  field :id,       !types.Int
  field :username, !types.String
  field :name,     !types.String
  field :author,   !types.String

  field :wads_count, !types.Int
end
