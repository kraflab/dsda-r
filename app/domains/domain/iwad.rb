module Domain
  module Iwad
    extend self

    def list
      ::Iwad.all
    end

    def single(short_name: nil, either_name: nil)
      return ::Iwad.find_by(username: short_name) if short_name
      if either_name
        return ::Iwad.find_by(username: either_name) ||
          ::Iwad.find_by(name: either_name)
      end
    end
  end
end
