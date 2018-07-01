module Domain
  module Port
    module Save
      extend self

      def call(port)
        remove_excess_whitespace!(port)
        port.save!
      end

      private

      def remove_excess_whitespace!(port)
        port.family.strip!.gsub!(/\s+/, ' ')
      end
    end
  end
end
