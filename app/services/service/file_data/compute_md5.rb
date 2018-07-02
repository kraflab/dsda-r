module Service
  module FileData
    module ComputeMd5
      extend self

      def call(object)
        return unless object.data&.file&.file
        Digest::MD5.hexdigest(object.data.file.read)
      end
    end
  end
end
