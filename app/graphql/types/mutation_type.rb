Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :authenticateUser, function: Mutations::AuthenticateUser.new
end
