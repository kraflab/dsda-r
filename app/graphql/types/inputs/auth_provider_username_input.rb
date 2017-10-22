Types::AuthProviderUsernameInput = GraphQL::InputObjectType.define do
  name 'AUTH_PROVIDER_USERNAME'

  argument :username, !types.String
  argument :password, !types.String
end
