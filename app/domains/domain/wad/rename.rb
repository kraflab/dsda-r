module Domain
  module Wad
    class Rename
      def self.call(wad, short_name)
        new(wad, short_name).call
      end

      def initialize(wad, short_name)
        @wad = wad
        @short_name = short_name
      end

      def call
        update_wad
        update_file_locations
      end

      private

      attr_reader :wad, :short_name

      def update_wad
        wad.update!(short_name: short_name)
      end

      def update_file_locations
        wad.demo_files.each do |file|
          update_file_location(file)
        end
      end

      def update_file_location(file)
        index = file.data.path.index('public/')
        public_dir = file.data.path[0...index] + 'public/'

        file.base_path = wad.short_name

        new_path = public_dir + \
                   file.data.store_dir + \
                   file.data.file.filename

        file.data.file.move_to(new_path)

        file.save!
      end
    end
  end
end
