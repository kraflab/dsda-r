if Rails.env.development?
  GraphiQL::Rails.config.headers['Authorization'] = -> (_ctx) {
    "bearer #{AuthToken.token(User.first)}"
  }
end
