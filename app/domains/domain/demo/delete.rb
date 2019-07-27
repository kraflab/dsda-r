module Domain
  module Demo
    module Delete
      extend self

      def call(demo)
        old_run = Run.new(demo)

        ::Demo.transaction do
          demo.destroy!
          cleanup_file(demo)
          touch_players(demo)
          update_record_fields(old_run)
        end
        demo
      end

      private

      # Invalidate player cache
      def touch_players(demo)
        demo.players.each { |i| i.touch }
      end

      def cleanup_file(demo)
        return unless demo.demo_file&.demos&.count == 0
        demo.demo_file.destroy!
      end

      def update_record_fields(old_run)
        Demo::UpdateRecordFields.call(old_run)
      end
    end
  end
end
