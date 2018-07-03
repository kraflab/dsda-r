module Domain
  module Player
    module Save
      extend self

      def call(player)
        format_strings(player)
        ::Player.transaction do
          touch_demos(player)
          player.save!
        end
      end

      private

      def format_strings(player)
        player.name = player.name.strip.gsub(/\s+/, ' ') if player.name.present?
        player.twitch ||= ''
        player.youtube ||= ''
      end

      # Rendering a demo includes the player name
      def touch_demos(player)
        return unless player.name_changed?
        player.demos.each { |i| i.touch }
      end
    end
  end
end
