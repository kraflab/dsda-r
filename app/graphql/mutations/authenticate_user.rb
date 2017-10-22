class Mutations::AuthenticateUser < GraphQL::function
  argument :username, !Types::AuthProviderUsernameInput

  type Types::AuthenticateType

  def call(_obj, args, _ctx)
    input = args[:username]
    return unless input

    user = User.find_by(username: args[:username])
    return unless user && user.authenticate(input[:password])

    OpenStruct.new({
      token: AuthToken.token(user),
      user:  user
    })
end
