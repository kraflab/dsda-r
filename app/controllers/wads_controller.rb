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
      @wads = Wad.paginate(page: params[:page])
      @is_paginated = true
    end
  end
  
  def show
    @wad = Wad.find_by(username: params[:id])
    @demos = @wad.demos
  end
  
  def new
    @wad = Wad.new
    @wad.iwad_username = params[:iwad]
  end
  
  def create
    @wad = Wad.new(wad_params)
    if @wad.save
      flash[:info] = "Wad successfully created"
      redirect_to wad_path(@wad)
    else
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
  end
  
  def update
    @old_username  = params[:wad][:old_username]
    @wad = Wad.find_by(username: @old_username)
    if @wad.update_attributes(wad_params)
      flash[:info] = "Wad successfully updated"
      redirect_to @wad
    else
      if @wad.iwad.nil?
        @wad.errors.add(:iwad_username, :not_found, message: "not found")
      end
      render 'edit'
    end
  end
  
  private
  
    def wad_params
      params.require(:wad).permit(:name, :username, :author, :file, :iwad_username)
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
