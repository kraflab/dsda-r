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

    def refresh_record_index(player: nil, players: nil)
      players = [player] if player.present?
      players = list if players == :all
      raise ArgumentError, 'No player provided' if players.blank?
      Player::RefreshRecordIndex.call(players)
    end
  end
end
