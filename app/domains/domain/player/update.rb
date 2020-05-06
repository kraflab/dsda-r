module Domain
  module Player
    class Update
      def self.call(player, attributes)
        new(player, attributes).call
      end

      def initialize(player, attributes)
        @player = player
        @old_attributes = player.attributes.with_indifferent_access
        @attributes = attributes
      end

      def call
        player.assign_attributes(attributes)

        ::Player.transaction do
          mark_suspect_demos
          Player::Save.call(player)
        end
      end

      private

      attr_reader :player, :old_attributes, :attributes

      def mark_suspect_demos
        return unless changed?(:cheater) && attributes[:cheater]

        player.demos.each do |demo|
          Domain::Demo::Update.call(demo, suspect: true)
        end
      end

      def changed?(attribute)
        old_attributes[attribute] != new_attributes[attribute]
      end

      def new_attributes
        @new_attributes ||= player.attributes.with_indifferent_access
      end
    end
  end
end
