module Domain
  module Demo
    module ComputeRecordIndex
      extend self

      def call(demo)
        return 0 if !demo.standard?

        categories = Domain::Category.list(soft_category: demo.category.name)
        return unless best?(demo, categories)
        record_index(demo, categories)
      end

      private

      def best?(demo, categories)
        least_tics = related_demos(demo, categories).first.tics
        demo.tics == least_tics
      end

      def related_demos(demo, categories)
        Demo.list(
          wad_id: demo.wad_id, level: demo.level, categories: categories,
          standard: true,
          order_by: :tics
        )
      end

      def record_index(demo, categories)
        categories = index_categories(demo, categories)
        related_demos(demo, categories).select { |d| d.tics > demo.tics }.count
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
