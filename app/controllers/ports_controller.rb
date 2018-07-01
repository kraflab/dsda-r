class PortsController < ApplicationController
  autocomplete :port, :family do |items|
    ActiveSupport::JSON.encode(items.uniq{ |i| i['value'] })
  end
  skip_before_action :verify_authenticity_token, only: [:api_create]
  before_action :authenticate_admin!, only: [:api_create]

  def index
    @ports = Domain::Port.list
  end

  def api_create
    preprocess_api_request(require: [:port])
    port = Domain::Port.create(@request_hash[:port])
    render json: PortSerializer.new(port).call
  end
end
