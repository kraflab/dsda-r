class IwadsController < ApplicationController
  before_action :admin_session, except: [:index, :show]
  before_action :age_limit, only: :destroy
  
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
    @iwad.destroy
    flash[:info] = "Iwad successfully deleted"
    redirect_to iwads_url
  end
  
  private
  
    def iwad_params
      params.require(:iwad).permit(:name, :username, :author)
    end
    
    # Allows destroy only for new items
    def age_limit
      @iwad = Iwad.find_by(username: params[:id])
      if @iwad.is_frozen?
        flash[:warning] = "That Iwad is too old to delete from here"
        redirect_to root_url
      end
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to root_url
      end
    end
end
