module Domain
  module Wad
    module TableLevelList
      extend self

      REJECT_LIST = [
        'Other Movie'
      ].freeze

      def call(wad, category)
        list = raw_list(wad) - REJECT_LIST

        unless Domain::Category.multiple_exits?(name: category)
          list = list.reject { |l| l =~ /s/ }
        end

        list
      end

      def raw_list(wad)
        wad.demos.ils.select(:level).distinct.map(&:level)
      end
    end
  end
end
