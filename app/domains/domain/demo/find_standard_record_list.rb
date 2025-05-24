module Domain
  module Demo
    module FindStandardRecordList
      extend self

      def call(wad_id:, levels:, category_options:)
        levels.map do |level|
          [level, FindStandardRecord.call(wad_id: wad_id, level: level, category_options: category_options)]
        end
      end
    end
  end
end
