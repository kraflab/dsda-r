module Domain
  module Wad
    module Create
      extend self

      def call(attributes)
        wad_file = wad_file(attributes)
        wad = ::Wad.new(attributes.merge(wad_file: wad_file))
        Wad::Save.call(wad)
        wad
      end

      private

      def wad_file(attributes)
        file = attributes.delete(:file)
        file_id = attributes.delete(:file_id)
        return ::WadFile.find(file_id) if file_id
        data = Service::FileData::Read.call(file_hash: file)
        ::WadFile.new(iwad: attributes[:iwad], data: data)
      end
    end
  end
end
