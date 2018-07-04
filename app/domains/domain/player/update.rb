module Domain
  module Player
    module Update
      extend self

      def call(player, attributes)
        player.assign_attributes(attributes)
        Player::Save.call(player)
      end
    end
  end
end
