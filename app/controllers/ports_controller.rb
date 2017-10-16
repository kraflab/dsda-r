class PortsController < ApplicationController
  autocomplete :port, :family do |items|
    ActiveSupport::JSON.encode(items.uniq{ |i| i['value'] })
  end
  skip_before_action :verify_authenticity_token, only: [:api_create]

  def index
    @ports = Port.all
  end

  def api_create
    query, response_hash, admin = preprocess_api_authenticate(request)
    # admin is nil unless authentication was successful
    if query and admin
      port_query = query['port']
      @port = Port.new(port_query.slice('family', 'version'))
      if has_file_data?(port_query)
        io = Base64StringIO.new(Base64.decode64(port_query['file']['data']))
        io.original_filename = port_query['file']['name'][0..31]
        @port.data = io
      end
      if @port.save
        response_hash[:save] = true
        response_hash[:port] = {id: @port.id, name: "#{@port.family} #{@port.version}"}
      else
        response_hash[:error_message].push 'Port creation failed', *@port.errors
      end
    end
    response_hash[:error] = (response_hash[:error_message].count > 0)
    render json: response_hash
  end
end
