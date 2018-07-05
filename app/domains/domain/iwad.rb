module Domain
  module Iwad
    extend self

    def list
      ::Iwad.all
    end

    def single(short_name: nil)
      return ::Iwad.find_by(username: short_name) if short_name
    end
  end
end
