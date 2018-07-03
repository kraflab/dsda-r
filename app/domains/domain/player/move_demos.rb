module Domain
  module Player
    module MoveDemos
      extend self

      def call(to_player:, from_player:)
        ::Player.transaction do
          from_player.player_demos.each do |demo|
            demo.update!(player: to_player)
          end
        end
      end
    end
  end
end
