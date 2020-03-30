class AdminAuthorizer
  def self.authorize!(admin, action)
    raise Errors::Unauthorized unless admin.send("can_#{action}")

    true
  end
end
