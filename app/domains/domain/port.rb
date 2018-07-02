module Domain
  module Port
    extend self

    def list
      ::Port.order(:family, :version).all
    end

    def create(family: nil, version: nil, file: nil)
      Port::Create.call(family: family, version: version, file: file)
    end
  end
end
