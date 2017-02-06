class PortsController < ApplicationController
  autocomplete :port, :family do |items|
    ActiveSupport::JSON.encode(items.uniq{ |i| i["value"] })
  end
  before_action :admin_session, except: [:index]
  
  def index
    @ports = Port.all
  end
  
  def new
    @port = Port.new
  end
  
  def create
    @port = Port.new(port_params)
    if @port.save
      flash[:info] = "Port successfully created"
      redirect_to ports_url
    else
      render 'new'
    end
  end
  
  def destroy
    family, version = parse_id
    Port.find_by(family: family, version: version).destroy
    flash[:info] = "Port successfully deleted"
    redirect_to ports_url
  end
  
  def edit
    family, version = parse_id
    puts "> #{family} #{version} <"
    @port = Port.find_by(family: family, version: version)
  end
  
  def update
    @port = Port.find(params[:port][:old_id])
    if @port.update_attributes(port_params)
      flash[:info] = "Port successfully updated"
      redirect_to ports_url
    else
      render 'edit'
    end
  end
  
  private
  
    def port_params
      params.require(:port).permit(:family, :version, :file)
    end
    
    def parse_id
      CGI::unescape(params[:id]).split(':')
    end

    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
