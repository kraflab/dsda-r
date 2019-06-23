module Domain
  module Demo
    module FindStandardRecordList
      extend self

      def call(wad_id, levels, category_options)
        levels.map do |level|
          [level, FindStandardRecord.call(wad_id, level, category_options)]
        end
      end
    end
  end
end
