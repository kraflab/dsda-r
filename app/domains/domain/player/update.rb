module Domain
  module Player
    class Update
      def self.call(player, attributes)
        new(player, attributes).call
      end

      def initialize(player, attributes)
        @player = player
        @old_attributes = player.attributes.with_indifferent_access
        @attributes = attributes.except(:alias)
        @new_alias = attributes[:alias]
      end

      def call
        player.assign_attributes(attributes)

        ::Player.transaction do
          update_aliases
          mark_suspect_demos
          Player::Save.call(player)
        end
      end

      private

      attr_reader :player, :old_attributes, :attributes, :new_alias

      def mark_suspect_demos
        return unless changed?(:cheater) && attributes[:cheater]

        player.demos.each do |demo|
          next if demo.tas?

          Domain::Demo::Update.call(demo, suspect: true)
        end
      end

      def update_aliases
        if new_alias
          ::PlayerAlias.create(name: new_alias, player_id: player.id)
        end

        if changed?(:username)
          ::PlayerAlias.create(name: old_attributes[:username], player_id: player.id)
        end

        if changed?(:name)
          ::PlayerAlias.create(name: old_attributes[:name], player_id: player.id)
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
