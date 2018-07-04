module Domain
  module Player
    module RefreshRecordIndex
      extend self

      def call(players)
        players.each do |player|
          record_index = record_index(player)
          next if record_index == player.record_index
          Player::Update.call(player, record_index: record_index(player))
        end
      end

      private

      def record_index(player)
        player.demos.reduce(0) { |sum, demo| sum + demo.record_index }
      end
    end
  end
end
