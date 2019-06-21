module Domain
  module Demo
    module FindStandardRecordList
      extend self

      def call(wad_id, levels, category)
        levels.map do |level|
          [level, FindStandardRecord.call(wad_id, level, category: category)]
        end
      end
    end
  end
end
