module Domain
  module Demo
    class Run
      attr_reader :wad_id, :category_id, :category_name, :level

      def initialize(demo)
        @wad_id = demo.wad_id
        @category_id = demo.category_id
        @category_name = demo.category_name
        @level = demo.level
        freeze
      end

      def self.eql?(a, b)
        a.wad_id == b.wad_id \
          && a.category_id == b.category_id \
          && a.level == b.level
      end
    end
  end
end
