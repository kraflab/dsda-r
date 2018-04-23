class PortSerializer
  def initialize(port)
    @port = port
  end

  def call
    {
      save: true,
      port: {
        id: @port.id,
        name: @port.full_name
      }
    }
  end
end
