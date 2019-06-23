module Domain
  module Category
    module ListForIwad
      extend self

      COMMON_CATEGORIES = [
        'Tyson',
        'Pacifist',
        'Stroller',
        'NoMo',
        'NoMo 100S',
        'Collector'
      ].freeze
      DOOM_CATEGORIES = [
        'UV Speed',
        'UV Max',
        'UV Fast',
        'UV Respawn',
        'NM Speed',
        'NM 100S'
      ].freeze
      HERETIC_CATEGORIES = [
        'SM Speed',
        'SM Max',
        'BP Speed',
        'BP Max',
        'NM Speed',
        'NM 100S'
      ].freeze
      HEXEN_CATEGORIES = [
        'Sk4 Speed',
        'Sk4 Max',
        'Sk5 Speed',
        'Sk5 Max'
      ].freeze

      def call(iwad)
        case iwad
        when 'heretic'
          heretic
        when 'hexen'
          hexen
        else
          doom
        end
      end

      private

      def heretic
        @heretic ||= (HERETIC_CATEGORIES + COMMON_CATEGORIES).map do |name|
          ::Category.find_by(name: name)
        end
      end

      def hexen
        @hexen ||= (HEXEN_CATEGORIES + COMMON_CATEGORIES).map do |name|
          ::Category.find_by(name: name)
        end
      end

      def doom
        @doom ||= (DOOM_CATEGORIES + COMMON_CATEGORIES).map do |name|
          ::Category.find_by(name: name)
        end
      end
    end
  end
end
