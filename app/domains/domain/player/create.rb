module Domain
  module Player
    module Create
      extend self

      def call(name:, username: nil, twitch: nil, youtube: nil)
        username ||= generate_username(name)
        player = ::Player.new({
          name: name, username: username, twitch: twitch, youtube: youtube
        })
        Player::Save.call(player)
        player
      end

      private

      def generate_username(name)
        I18n.transliterate(name)
          .downcase
          .strip
          .gsub(/\s+/, '_')
          .gsub(/[^a-z\d_-]+/, '')
      end
    end
  end
end
