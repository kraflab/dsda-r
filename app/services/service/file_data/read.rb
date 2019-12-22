module Service
  module FileData
    module Read
      extend self

      FILE_NAME_LIMIT = 47

      def call(file_hash: nil)
        return unless file_data_exists?(file_hash)
        file_data_from_hash(file_hash)
      end

      private

      def file_data_exists?(file_hash)
        file_hash && file_hash[:data] && file_hash[:name]
      end

      def file_data_from_hash(file_hash)
        data = Base64StringIO.new(Base64.decode64(file_hash[:data]))
        data.original_filename = file_hash[:name][0..FILE_NAME_LIMIT]
        data
      end
    end
  end
end
