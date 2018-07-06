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
      iwad:, name:, short_name:, author:,
      year: nil, compatibility: nil, is_commercial: nil, single_map: false,
      file: nil, file_id: nil
    )
      iwad = Domain::Iwad.single(either_name: iwad)
      Domain::Iwad::Create.call(
        iwad: iwad,
        name: name,
        short_name: short_name,
        author: author,
        year: year,
        compatibility: compatibility,
        is_commercial: is_commercial,
        single_map: single_map,
        file: file,
        file_id: file_id
      )
    end
  end
end
