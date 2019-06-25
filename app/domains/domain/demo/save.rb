module Domain
  module Demo
    module Save
      extend self

      def call(demo)
        previous_record = standard_record(demo)
        format_levelstat(demo)
        store_md5(demo)
        ::Demo.transaction do
          demo.save!
          Demo::UpdateRecordFields.call(demo)
          refresh_record_index(previous_record, demo)
          touch_players(demo)
        end
      end

      private

      def format_levelstat(demo)
        demo.levelstat.gsub!(/,/, "\n")
      end

      def store_md5(demo)
        demo.demo_file.md5 = Service::FileData::ComputeMd5.call(demo.demo_file)
      end

      def standard_record(demo)
        return unless demo.standard?

        Demo::FindStandardRecord.call(
          demo.wad_id, demo.level, category_id: demo.category_id
        )
      end

      def refresh_record_index(previous_record, demo)
        return unless demo.standard?

        refresh_player_record_index(previous_record) if previous_record
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
