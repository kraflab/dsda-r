module Domain
  module Player
    class Merge
      def self.call(from:, into:)
        new(from: from, into: into).call
      end

      def initialize(from:, into:)
        @from = from
        @into = into
      end

      def call
        transfer_record_index
        transfer_demos

        ::Player.transaction do
          register_aliases
          Player::Save.call(into)
          from.destroy!
        end
      end

      private

      attr_reader :from, :into

      def transfer_record_index
        into.record_index += from.record_index
      end

      def transfer_demos
        from.demos.each do |demo|
          players = demo.players.to_a
          players.delete(from)
          players << into
          demo.players = players
        end
      end

      def register_aliases
        ::PlayerAlias.create(name: from.name, player_id: into.id)
        ::PlayerAlias.create(name: from.username, player_id: into.id)
      end
    end
  end
end
