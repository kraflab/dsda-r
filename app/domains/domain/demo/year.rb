module Domain
  module Demo
    module Year
      extend self

      def increment(datetime)
        return if datetime.nil?

        demo_year = demo_year_from_datetime(datetime)
        demo_year.with_lock do
          demo_year.increment!(:count)
        end
      end

      def decrement(datetime)
        return if datetime.nil?

        demo_year = demo_year_from_datetime(datetime)
        demo_year.with_lock do
          demo_year.decrement!(:count)
        end
      end

      private

      def demo_year_from_datetime(datetime)
        ::DemoYear.find_or_create_by(year: datetime.year)
      end
    end
  end
end
