# This file is certainly violating domain boundaries
# It is a temporary step on the path to encapsulation
module Domain
  module Player
    module Stats
      extend self

      def call(player)
        OpenStruct.new(
          longest_demo_time: longest_demo_time(player),
          average_demo_time: average_demo_time(player),
          total_demo_time: total_demo_time(player),
          average_demo_count: average_demo_count(player),
          most_recorded_wad: most_recorded_wad(player),
          most_recorded_category: most_recorded_category(player)
          tas_count: tas_count(player),
          wad_count: wad_count(player),
          demo_count: demo_count(player)
        )
      end

      private

      def longest_demo_time(player)
        ::Demo.tics_to_string(player.demos.maximum(:tics))
      end

      def average_demo_time(player)
        ::Demo.tics_to_string(player.demos.sum(:tics) / player.demos.count)
      end

      def total_demo_time
        ::Demo.tics_to_string(player.demos.sum(:tics))
      end

      def average_demo_count(player)
        wad_counts = player.demos.group(:wad_id).count
        wad_counts.values.inject(0) { |sum, k| sum + k } / wad_counts.size
      end

      def most_recorded_wad(player)
        wad_counts = player.demos.group(:wad_id).count
        ::Wad.find(wad_counts.max_by { |k, v| v }[0]).name
      end

      def most_recorded_category(player)
        category_counts = player.demos.group(:category_id).count
        ::Category.find(category_counts.max_by { |k, v| v }[0]).name
      end

      def tas_count(player)
        player.demos.tas.count
      end

      def wad_count(player)
        player.demos.select(:wad_id).distinct.count
      end

      def demo_count(player)
        player.demos.count
      end
    end
  end
end
