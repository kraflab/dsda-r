class IwadsController < ApplicationController
  before_action :admin_session, except: [:index, :show]
  
  def index
    @iwads = Iwad.all
  end
  
  def show
    @iwad = Iwad.find_by(username: params[:id])
    @wads = @iwad.wads
  end
  
  def new
    @iwad = Iwad.new
  end
  
  def create
    @iwad = Iwad.new(iwad_params)
    if @iwad.save
      flash[:info] = "Iwad successfully created"
      redirect_to iwad_path(@iwad)
    else
      render 'new'
    end
  end
  
  def destroy
    Iwad.find_by(username: params[:id]).destroy
    flash[:info] = "Iwad successfully deleted"
    redirect_to iwads_url
  end
  
  private
  
    def iwad_params
      params.require(:iwad).permit(:name, :username, :author)
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
