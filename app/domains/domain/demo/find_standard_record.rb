module Domain
  module Demo
    module FindStandardRecord
      extend self

      def call(wad_id, level, category)
        categories = Domain::Category.list(soft_category: category)

        ::Demo
          .where(wad_id: wad_id)
          .where(level: level)
          .where(category: categories)
          .where(guys: 1)
          .where(tas: false)
          .reorder(:tics)
          .first
      end
    end
  end
end
