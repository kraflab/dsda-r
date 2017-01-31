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
    @iwad = Iwad.find_by(username: params[:id])
    if @iwad
      @iwad.destroy
      flash[:info] = "Iwad successfully deleted"
    else
      flash[:danger] = "Delete failed, unknown username"
    end
    redirect_to iwads_url
  end
  
  def edit
    @iwad = Iwad.find_by(username: params[:id])
  end
  
  def update
    old_username = params[:iwad][:old_username]
    @iwad = Iwad.find_by(username: old_username)
    if @iwad && @iwad.update_attributes(iwad_params)
      flash[:info] = "Iwad successfully updated"
      redirect_to @iwad
    else
      @iwad = Iwad.find_by(username: params[:id])
      render 'edit'
    end
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
