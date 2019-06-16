module Domain
  module Demo
    module FindStandardRecord
      extend self

      def call(wad_id, level, category_options)
        RelevantDemoList.call(wad_id, level, category_options).first
      end
    end
  end
end
