module Domain
  module Wad
    module Save
      extend self

      def call(wad)
        remove_excess_whitespace!(wad)
        store_md5(wad)

        ::Wad.transaction do
          wad.save!
          touch_demos(wad)
        end
      end

      private

      def remove_excess_whitespace!(wad)
        wad.name.strip!
        wad.name.gsub!(/\s+/, ' ')
        wad.author.strip!
        wad.author.gsub!(/\s+/, ' ')
      end

      def store_md5(wad)
        return unless wad.wad_file

        wad.wad_file.md5 = Service::FileData::ComputeMd5.call(wad.wad_file)
      end

      # Invalidate demo cache
      def touch_demos(wad)
        wad.demos.each { |i| i.touch }
      end
    end
  end
end
