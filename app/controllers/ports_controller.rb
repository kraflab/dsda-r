class PortsController < ApplicationController
  autocomplete :port, :family do |items|
    ActiveSupport::JSON.encode(items.uniq{ |i| i['value'] })
  end
  before_action :admin_session, except: [:index]
  before_action :age_limit, only: :destroy

  def index
    @ports = Port.all
  end

  def new
    @port = Port.new
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
