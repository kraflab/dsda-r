module Domain
  module Demo
    class FindMatches
      def self.call(details)
        new(details).call
      end

      def initialize(details)
        @details = details
      end

      def call
        return [] unless wad_id && category_id && level

        initialize_query
        query_time
        query_player
        query_tas
        query_solo_net
        query_coop

        query
      end

      private

      attr_reader :details, :query

      def initialize_query
        @query = ::Demo.where(
          wad_id: wad_id, category_id: category_id, level: level
        )
      end

      def query_time
        return unless tics

        @query = query.where(tics: tics)
      end

      def query_player
        return unless details[:player]

        @query = query.joins(:demo_players).where(
          'demo_players.player_id = ?', player_id
        )
      end

      def query_tas
        return if details[:tas].nil?

        @query = query.where(tas: details[:tas])
      end

      def query_solo_net
        return if details[:solo_net].nil?

        @query = query.where(solo_net: details[:solo_net])
      end

      def query_coop
        return if details[:coop].nil?

        @query = query.where('guys > 1')
      end

      def wad_id
        @wad_id ||= Domain::Wad.single(either_name: details[:wad])&.id
      end

      def category_id
        @category_id ||= Domain::Category.single(name: details[:category])&.id
      end

      def player_id
        return unless details[:player]

        @player_id ||= Domain::Player.single(either_name: details[:player])&.id
      end

      def tics
        return unless details[:time]

        @tics ||= Service::Tics::FromString.call(details[:time]).first
      end

      def level
        details[:level]
      end
    end
  end
end
