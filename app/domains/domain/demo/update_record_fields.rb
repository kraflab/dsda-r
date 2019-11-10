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
        return if demo.category_name == 'Other'

        reset_demos
        return if demos_for_category.count < 2

        save_record
        save_second_record
        update_record_index

        chain_affected_categories
      end

      private

      attr_reader :demo

      # Only reset for the specific category
      def reset_demos
        demos_for_category.where('record_index > 0').update_all(record_index: 0, updated_at: Time.now)
        demos_for_category.where(tic_record: true).update_all(tic_record: false, updated_at: Time.now)
        demos_for_category.where(second_record: true).update_all(second_record: false, updated_at: Time.now)
      end

      def update_record_index
        record_index_demos = demos.where.not(record_index: 0).to_a
        record_index_demos |= [record]
        record_index_demos.each do |d|
          record_index = Domain::Demo::ComputeRecordIndex.call(d).to_i
          d.update!(record_index: record_index)
        end
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

      def chain_affected_categories
        return unless demo.category_name == 'Pacifist'

        speed_record = FindStandardRecord.call(wad_id, level, only: :skill_4_speed)
        UpdateRecordFields.call(speed_record) if speed_record
      end
    end
  end
end
