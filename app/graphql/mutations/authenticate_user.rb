class Mutations::AuthenticateUser < GraphQL::Function
  argument :username, !types.String
  argument :password, !types.String

  type Types::UserTokenType

  def call(_obj, args, _ctx)
    username = args[:username]
    password = args[:password]
    raise AuthenticationFailure unless username && password

    user = User.find_by(username: username)
    raise AuthenticationFailure unless user && user.authenticate(password)

    OpenStruct.new({
      token: AuthToken.token(user),
      username:  user.username
    })
  rescue AuthenticationFailure
    GraphQL::ExecutionError.new('Authentication failure.')
  end
end
