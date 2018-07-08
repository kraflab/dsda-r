module Domain
  module Demo
    module Save
      extend self

      def call(demo)
        format_levelstat(demo)
        store_md5(demo)
        ::Demo.transaction do
          demo.save!
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

      # Invalidate player cache
      def touch_players(demo)
        demo.players.each { |i| i.touch }
      end
    end
  end
end
