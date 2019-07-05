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
    end
  end
end
