module Domain
  module Wad
    extend self

    def list(letter: nil, numbers: nil, page: nil)
      query = ::Wad.all
      query = query.where('username LIKE ?', "#{letter}%") if letter
      query = number_regex_query(query) if numbers
      query = query.page(page) if page
      query
    end

    def search(term:)
      ::Wad.where('username LIKE ? OR name LIKE ?', "%#{term}%", "%#{term}%")
    end

    def single(short_name: nil, either_name: nil, id: nil, assert: false)
      wad = nil
      wad = ::Wad.find_by(username: short_name) if short_name
      wad = find_by_either_name(either_name) if either_name
      wad = ::Wad.find_by(id: id) if id
      return wad if wad.present?
      raise ActiveRecord::RecordNotFound if assert
    end

    def create(
      iwad:, name:, short_name:, author:,
      year: nil, compatibility: nil, is_commercial: nil, single_map: false,
      file: nil, file_id: nil
    )
      iwad = Domain::Iwad.single(either_name: iwad)
      Domain::Wad::Create.call(
        iwad: iwad,
        name: name,
        username: short_name,
        author: author,
        year: year,
        compatibility: compatibility,
        is_commercial: is_commercial,
        single_map: single_map,
        file: file,
        file_id: file_id
      )
    end

    private

    def number_regex_query(query)
      return query.where('username ~ ?', '^[0-9]') if Rails.env.production?
      query.where('username REGEXP ?', '^[0-9]')
    end

    def find_by_either_name(either_name)
      ::Wad.find_by(username: either_name) || ::Wad.find_by(name: either_name)
    end
  end
end
