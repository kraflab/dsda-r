class PortCreationService
  BASE_ATTRIBUTES = [:family, :version].freeze

  def initialize(request_hash)
    @request_hash = request_hash
  end

  def create!
    new_port.tap { |port| port.save! }
  end

  private

  def new_port
    Port.new(port_attributes)
  end

  def port_attributes
    @request_hash.slice(*BASE_ATTRIBUTES).merge(data: port_data)
  end

  def new_data
    io = Base64StringIO.new(Base64.decode64(@request_hash[:file][:data]))
    io.original_filename = @request_hash[:file][:name][0..31]
    io
  end

  def has_file_data?
    @request_hash[:file] && @request_hash[:file][:data] && @request_hash[:file][:name]
  end

  def port_data
    return new_data if has_file_data?
  end
end
