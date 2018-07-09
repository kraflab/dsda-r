module Domain
  module Demo
    module Delete
      extend self

      def call(demo)
        ::Demo.transaction do
          demo.destroy!
          cleanup_file(demo)
          touch_players(demo)
        end
        demo
      end

      private

      # Invalidate player cache
      def touch_players(demo)
        demo.players.each { |i| i.touch }
      end

      def cleanup_file(demo)
        return unless demo.demo_file&.demos&.count == 1
        demo.demo_file.destroy!
      end
    end
  end
end
