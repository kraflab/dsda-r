class PortsController < ApplicationController
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
      redirect_to port_path(@port)
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
    @port = Port.find_by(family: family, version: version)
    @old_id = @port.id
  end
  
  def update
    @old_id = params[:port][:old_id]
    @port = Port.find(@old_id)
    if @port.update_attributes(port_params)
      flash[:info] = "Port successfully updated"
      redirect_to @port
    else
      render 'edit'
    end
  end
  
  private
  
    def port_params
      params.require(:port).permit(:family, :version, :file)
    end
    
    def parse_id
      params[:id].split(':')
    end

    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
