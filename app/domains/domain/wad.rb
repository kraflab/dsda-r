module Domain
  module Wad
    extend self

    def list
      ::Wad.all
    end

    def single(short_name: nil)
      return ::Wad.find_by(username: short_name) if short_name
    end

    def create(
      iwad:, name:, short_name:, author:
      year: nil, compatibility: nil, is_commercial: nil, single_map: false,
      file: nil
    )
      iwad = Domain::Iwad.single(either_name: iwad)
      # Domain::Iwad::Create.call()
    end
  end
end
