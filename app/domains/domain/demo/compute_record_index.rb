module Domain
  module Demo
    module ComputeRecordIndex
      extend self

      def call(demo)
        categories = Domain::Category.list(soft_category: demo.category.name)
        return unless best?(demo, categories)
        record_index(demo, categories)
      end

      private

      def best?(demo, categories)
        least_tics = related_demos(demo, categories).first.tics
        demo.tics / 100 <= least_tics / 100
      end

      def related_demos(demo, categories)
        Demo.list(
          wad_id: demo.wad_id, level: demo.level, categories: categories,
          tas: demo.tas, guys: demo.guys, order_by_tics: true
        )
      end

      def record_index(demo, categories)
        categories = index_categories(demo, categories)
        related_demos(demo, categories).count - 1
      end

      def index_categories(demo, categories)
        categories.pop(categories.size - 1) if categories.size > 1
        if demo.category.name == 'Pacifist'
          categories.push(*Domain::Category.list(only: :skill_4_speed))
          # Only add speed category if pacifist is also the speed record
          categories.pop(categories.size - 1) unless best?(demo, categories)
        end
        categories
      end
    end
  end
end
