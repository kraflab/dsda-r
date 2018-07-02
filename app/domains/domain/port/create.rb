module Domain
  module Port
    module Create
      extend self

      def call(family: nil, version: nil, file: nil)
        data = Service::FileData::Read.call(file_hash: file)
        port = ::Port.new(family: family, version: version, data: data)
        Port::Save.call(port)
        port
      end
    end
  end
end
