module Domain
  module Demo
    module RelevantDemoList
      extend self

      def call(wad_id, level, category: nil, category_id: nil)
        categories = Domain::Category.list(
          soft_category: category, soft_category_id: category_id
        )

        ::Demo
          .where(wad_id: wad_id)
          .where(level: level)
          .where(category: categories)
          .standard
          .reorder(:tics)
      end
    end
  end
end
