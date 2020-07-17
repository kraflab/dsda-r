module Domain
  module Wad
    class Update
      def self.call(wad, attributes)
        new(wad, attributes).call
      end

      def initialize(wad, attributes)
        @wad = wad
        @old_attributes = wad.attributes.with_indifferent_access
        @attributes = attributes
      end

      def call
        wad_file = new_wad_file
        attributes[:wad_file] = wad_file if wad_file

        wad.assign_attributes(attributes)

        ::Wad.transaction do
          Wad::Save.call(wad)
          cleanup_file
        end
      end

      private

      attr_reader :wad, :attributes, :old_attributes

      def new_wad_file
        file = attributes.delete(:file)
        file_id = attributes.delete(:file_id)

        return ::WadFile.find(file_id) if file_id
        return if file.nil?

        data = Service::FileData::Read.call(file_hash: file)
        iwad = attributes[:iwad] || wad.iwad
        ::WadFile.new(
          iwad: iwad,
          base_path: iwad&.short_name,
          data: data
        )
      end

      def cleanup_file
        return unless changed?(:wad_file_id) && old_attributes[:wad_file_id]

        old_wad_file = ::WadFile.find(old_attributes[:wad_file_id])
        return unless old_wad_file.wads.count == 0

        old_wad_file.destroy!
      end

      def changed?(attribute)
        old_attributes[attribute] != new_attributes[attribute]
      end

      def new_attributes
        @new_attributes ||= wad.attributes.with_indifferent_access
      end
    end
  end
end
