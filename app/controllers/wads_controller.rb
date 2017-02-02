class WadsController < ApplicationController
  before_action :admin_session, except: [:index, :show]
  
  def index
    letter = params[:letter]
    if (/\A[a-z9]\z/ =~ letter) == 0
      if letter == "9"
        @wads = Wad.where("username REGEXP ?", "^[0-9]")
      else
        @wads = Wad.where("username LIKE ?", "#{letter}%")
      end
    else
      @wads = Wad.all
    end
  end
  
  def show
    @wad = Wad.find_by(username: params[:id])
  end
  
  def new
    @wad = Wad.new
    @iwad_username = params[:iwad_username] || ""
  end
  
  def create
    @iwad_username = params[:wad][:iwad_username]
    iwad = Iwad.find_by(username: @iwad_username)
    these_params = wad_params
    if iwad
      these_params[:iwad_id] = iwad.id
      @wad = Wad.new(these_params)
      if @wad.save
        flash[:info] = "Wad successfully created"
        redirect_to wad_path(@wad)
      else
        render 'new'
      end
    else
      these_params[:iwad_id] = nil
      @wad = Wad.new(these_params)
      flash.now[:danger] = "Iwad not found"
      render 'new'
    end
  end
  
  def destroy
    Wad.find_by(username: params[:id]).destroy
    flash[:info] = "Wad successfully deleted"
    redirect_to wads_url
  end
  
  def edit
    @wad = Wad.find_by(username: params[:id])
    @old_username = @wad.username
    @iwad_username = @wad.iwad.username
  end
  
  def update
    @old_username  = params[:wad][:old_username]
    @iwad_username = params[:wad][:iwad_username]
    these_params  = wad_params
    @wad = Wad.find_by(username: @old_username)
    iwad = Iwad.find_by(username: @iwad_username)
    if iwad
      these_params[:iwad_id] = iwad.id
      if @wad.update_attributes(these_params)
        flash[:info] = "Wad successfully updated"
        redirect_to @wad
      else
        render 'edit'
      end
    else
      flash.now[:danger] = "Iwad not found"
      render 'edit'
    end
  end
  
  private
  
    def wad_params
      params.require(:wad).permit(:name, :username, :author, :file)
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
