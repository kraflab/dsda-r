module Domain
  module Player
    module RefreshRecordIndex
      extend self

      def call(player: nil, players: nil)
        players = [player] if player.present?
        raise ArgumentError, 'No player provided' if players.blank?
        refresh_record_index(players)
      end

      private

      def refresh_record_index(players)
        players.each do |player|
          record_index = record_index(player)
          next if record_index == player.record_index
          Player::Update.call(player, record_index: record_index(player))
        end
      end

      def record_index(player)
        player.demos.reduce(0) { |sum, demo| sum + demo.record_index }
      end
    end
  end
end
