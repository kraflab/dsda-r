module Domain
  module Demo
    module RelevantDemoList
      extend self

      def call(wad_id, level, category: nil, category_id: nil, very_soft: nil)
        categories = Domain::Category.list(
          soft_category: category,
          soft_category_id: category_id,
          very_soft: very_soft
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
