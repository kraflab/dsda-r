# This file is certainly violating domain boundaries
# It is a temporary step on the path to encapsulation
module Domain
  module Iwad
    module Stats
      extend self

      def call(iwad)
        OpenStruct.new(
          average_demo_time: average_demo_time(iwad),
          total_demo_time: total_demo_time(iwad),
          demo_count: demo_count(iwad),
          player_count: player_count(iwad),
          wad_count: wad_count(iwad)
        )
      end

      private

      def average_demo_time(iwad)
        ::Demo.tics_to_string(iwad.demos.sum(:tics) / iwad.demos.count)
      end

      def total_demo_time(iwad)
        ::Demo.tics_to_string(iwad.demos.sum(:tics))
      end

      def demo_count(iwad)
        iwad.demos.count
      end

      def player_count(iwad)
        ::DemoPlayer.where(demo: iwad.demos).select(:player_id).distinct.count
      end

      def wad_count(iwad)
        iwad.wads.count
      end
    end
  end
end
