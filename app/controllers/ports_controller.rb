class PortsController < ApplicationController
  autocomplete :port, :family do |items|
    ActiveSupport::JSON.encode(items.uniq{ |i| i['value'] })
  end
  before_action :admin_session, except: [:index, :api_create]
  before_action :age_limit, only: :destroy
  skip_before_action :verify_authenticity_token, only: [:api_create]

  def index
    @ports = Port.all
  end

  def new
    @port = Port.new
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

  def create
    @port = Port.new(port_params)
    if @port.save
      flash[:info] = 'Port successfully created'
      redirect_to ports_url
    else
      render 'new'
    end
  end

  def destroy
    @port.destroy
    flash[:info] = 'Port successfully deleted'
    redirect_to ports_url
  end

  private

    def port_params
      params.require(:port).permit(:family, :version, :data)
    end

    def parse_id
      CGI::unescape(params[:id]).split(':')
    end

    # Allows destroy only for new items
    def age_limit
      family, version = parse_id
      @port = Port.find_by(family: family, version: version)
      if @port.is_frozen?
        flash[:warning] = 'That Port is too old to delete from here'
        redirect_to root_url
      end
    end

    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = 'You must be logged in to perform this action'
        redirect_to(root_url)
      end
    end
end
