module Domain
  module Player
    extend self

    def list
      ::Player.all
    end

    def single(username: nil)
      return ::Player.find_by(username: username) if username
    end

    def create(name:, username: nil, twitch: nil, youtube: nil)
      Player::Create.call(
        name: name, username: username, twitch: twitch, youtube: youtube
      )
    end
  end
end
