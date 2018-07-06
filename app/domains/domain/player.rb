module Domain
  module Player
    extend self

    def list(by_record_index: false, limit: nil)
      query = ::Player.all
      query = query.record_index_order if by_record_index
      query = query.limit(limit) if limit
      query
    end

    def search(term:)
      ::Player.where('username LIKE ? OR name LIKE ?', "%#{term}%", "%#{term}%")
    end

    def single(username: nil, id: nil, assert: false)
      player = nil
      player = ::Player.find_by(username: username) if username
      player = ::Player.find_by(id: id) if id
      return player if player.present?
      raise ActiveRecord::RecordNotFound if assert
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
