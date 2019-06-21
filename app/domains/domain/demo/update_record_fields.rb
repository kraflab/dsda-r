module Domain
  module Demo
    class UpdateRecordFields
      delegate :wad_id, :level, :category_id, to: :demo

      def initialize(demo)
        @demo = demo
      end

      def self.call(demo)
        new(demo).call
      end

      def call
        reset_demos
        return if demos_for_category.count < 2
        save_record
        save_second_record
      end

      private

      attr_reader :demo

      # Only reset for the specific category
      def reset_demos
        demos_for_category.update_all(tic_record: false, second_record: false)
      end

      def save_record
        return unless record.category_id == category_id

        record.update!(tic_record: true)
      end

      def save_second_record
        return if record == second_record
        return unless second_record.category_id == category_id

        second_record.update!(second_record: true)
      end

      def record
        @record ||=
          FindStandardRecord.call(wad_id, level, category_id: category_id)
      end

      def second_record
        @second_record ||=
          demos.at_second(record.second).reorder(:recorded_at).first
      end

      def demos
        @demos ||=
          RelevantDemoList.call(wad_id, level, category_id: category_id)
      end

      def demos_for_category
        @demos_for_category ||= demos.where(category_id: category_id)
      end
    end
  end
end
