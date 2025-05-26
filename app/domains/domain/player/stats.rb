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
          most_recorded_category: most_recorded_category(player),
          tas_count: tas_count(player),
          wad_count: wad_count(player),
          demo_count: demo_count(player)
        )
      end

      private

      def longest_demo_time(player)
        Service::Tics::ToString.call(player.demos.maximum(:tics))
      end

      def average_demo_time(player)
        Service::Tics::ToString.call(player.demos.count != 0 ? player.demos.sum(:tics) / player.demos.count : 0)
      end

      def total_demo_time(player)
        Service::Tics::ToString.call(player.demos.sum(:tics))
      end

      def average_demo_count(player)
        demo_count(player) / wad_count(player)
      end

      def most_recorded_wad(player)
        wad_ids = player.demos.select(:wad_id).map(&:wad_id)
        return '' if wad_ids.empty?

        counts = wad_ids.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
        wad_id = counts.max_by { |_, v| v }[0]
        Domain::Wad.single(id: wad_id)&.name
      end

      def most_recorded_category(player)
        category_ids = player.demos.select(:category_id).map(&:category_id)
        return '' if category_ids.empty?

        counts = category_ids.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
        category_id = counts.max_by { |_, v| v }[0]
        Domain::Category.single(id: category_id)&.name
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
