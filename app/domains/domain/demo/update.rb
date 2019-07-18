module Domain
  module Demo
    class Update
      def self.call(demo, attributes)
        new(demo, attributes).call
      end

      def initialize(demo, attributes)
        @demo = demo
        @old_attributes = demo.attributes.with_indifferent_access
        @old_run = Run.new(demo)
        @attributes = attributes
      end

      def call
        demo.assign_attributes(attributes)

        ::Demo.transaction do
          Demo::Save.call(demo, old_run)
          adjust_demo_year_cache
        end
      end

      private

      attr_reader :demo, :old_attributes, :attributes, :old_run

      def adjust_demo_year_cache
        return unless changed?(:year)

        Demo::Year.decrement(old_attributes[:recorded_at])
        Demo::Year.increment(new_attributes[:recorded_at])
      end

      def changed?(attribute)
        old_attributes[attribute] != new_attributes[attribute]
      end

      def new_attributes
        @new_attributes ||= demo.attributes.with_indifferent_access
      end
    end
  end
end
