# This file is certainly violating domain boundaries
# It is a temporary step on the path to encapsulation
module Domain
  module Wad
    module Stats
      extend self

      def call(wad)
        OpenStruct.new(
          longest_demo_time: longest_demo_time(wad),
          average_demo_time: average_demo_time(wad),
          total_demo_time: total_demo_time(wad),
          most_recorded_player: most_recorded_player(wad),
          player_count: player_count(wad),
          demo_count: demo_count(wad)
        )
      end

      private

      def longest_demo_time(wad)
        ::Demo.tics_to_string(wad.demos.maximum(:tics))
      end

      def average_demo_time(wad)
        ::Demo.tics_to_string(wad.demos.sum(:tics) / wad.demos.count)
      end

      def total_demo_time(wad)
        ::Demo.tics_to_string(wad.demos.sum(:tics))
      end

      def most_recorded_player(wad)
        counts = ::DemoPlayer.where(demo: wad.demos).group(:player_id).count
        Domain::Player.single(id: counts.max_by { |k, v| v }[0]).name
      end

      def player_count(wad)
        ::DemoPlayer.where(demo: wad.demos).select(:player_id).distinct.count
      end

      def demo_count(wad)
        wad.demos.count
      end
    end
  end
end
