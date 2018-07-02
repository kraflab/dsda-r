module Domain
  module Port
    module Save
      extend self

      def call(port)
        remove_excess_whitespace!(port)
        store_md5(port)
        port.save!
      end

      private

      def remove_excess_whitespace!(port)
        return unless port.family
        port.family.strip!
        port.family.gsub!(/\s+/, ' ')
      end

      def store_md5(port)
        port.md5 = Service::FileData::ComputeMd5.call(port)
      end
    end
  end
end
