module Domain
  module Demo
    module FindStandardRecord
      extend self

      def call(wad_id:, level:, category_options:nil, category_id:nil, very_soft:nil, only:nil)
        RelevantDemoList.call(wad_id: wad_id, level: level, category: category_options, category_id: category_id, very_soft: very_soft, only: only).first
      end
    end
  end
end
