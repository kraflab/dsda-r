module Domain
  module Iwad
    extend self

    def list
      ::Iwad.all
    end

    def single(short_name: nil, either_name: nil, assert: false)
      iwad = nil
      iwad = ::Iwad.find_by(short_name: short_name) if short_name
      iwad = find_by_either_name(either_name) if either_name
      return iwad if iwad.present?
      raise ActiveRecord::RecordNotFound if assert
    end

    private

    def find_by_either_name(either_name)
      ::Iwad.find_by(short_name: either_name) || ::Iwad.find_by(name: either_name)
    end
  end
end
