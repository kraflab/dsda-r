require 'stringio'

class Base64StringIO < StringIO
  attr_accessor :original_filename
end
