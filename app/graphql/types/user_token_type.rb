Types::UserTokenType = GraphQL::ObjectType.define do
  name 'UserToken'

  field :token,    !types.String
  field :username, !types.String
end
