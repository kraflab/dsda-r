module Domain
  module Demo
    module Save
      extend self

      def call(demo, old_run = nil)
        previous_record = standard_record(demo)
        linked_record = standard_linked_record(demo)
        format_levelstat(demo)
        assign_year(demo)
        assign_suspect(demo)
        store_md5(demo)
        ::Demo.transaction do
          demo.save!
          update_record_fields(demo, old_run)
          refresh_record_index(previous_record, linked_record, demo)
          touch_players(demo)
        end
      end

      private

      def assign_year(demo)
        demo.year = demo.recorded_at&.year
      end

      def assign_suspect(demo)
        return unless demo.players.any?(&:cheater?) && !demo.tas?

        demo.suspect = true
      end

      def format_levelstat(demo)
        demo.levelstat.gsub!(/,/, "\n")
      end

      def store_md5(demo)
        demo.demo_file.md5 = Service::FileData::ComputeMd5.call(demo.demo_file)
      end

      def standard_record(demo)
        Demo::FindStandardRecord.call(
          demo.wad_id, demo.level, category_id: demo.category_id
        )
      end

      def standard_linked_record(demo)
        return unless demo.category_name == 'Pacifist'

        Demo::FindStandardRecord.call(
          demo.wad_id, demo.level, only: :skill_4_speed
        )
      end

      def update_record_fields(demo, old_run)
        Demo::UpdateRecordFields.call(demo)

        return unless old_run && !Run.eql?(old_run, demo)

        Demo::UpdateRecordFields.call(old_run)
      end

      def refresh_record_index(previous_record, linked_record, demo)
        refresh_player_record_index(previous_record) if previous_record
        refresh_player_record_index(linked_record) if linked_record
        refresh_player_record_index(demo) if demo.tic_record?
      end

      def refresh_player_record_index(demo)
        Domain::Player.refresh_record_index(players: demo.players)
      end

      # Invalidate player cache
      def touch_players(demo)
        demo.players.each { |i| i.touch }
      end
    end
  end
end
