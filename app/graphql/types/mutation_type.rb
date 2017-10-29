Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :userToken, function: Mutations::AuthenticateUser.new
end
