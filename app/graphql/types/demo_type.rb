Types::DemoType = GraphQL::ObjectType.define do
  name 'Demo'

  field :id,    !types.Int
  field :level, !types.String

  field :players, !types[Types::PlayerType]
  field :category_name, !types.String
  field :time, !types.String
end
