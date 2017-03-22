class WadsController < ApplicationController
  before_action :admin_session, except: [:index, :show, :record_timeline,
                                                        :record_timeline_json]
  before_action :age_limit, only: :destroy
  
  def index
    letter = params[:letter]
    if (/\A[a-z9]\z/ =~ letter) == 0
      if letter == "9"
        @wads = Rails.env.production? ?
          Wad.where("username ~ ?", "^[0-9]") :
          Wad.where("username REGEXP ?", "^[0-9]")
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
    @wad.iwad_username = params[:iwad] if params[:iwad]
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
    @wad.destroy
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
    params[:wad][:username] = @wad.username if @wad.is_frozen?
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
  
  def record_timeline_json
    @wad = Wad.find_by(username: params[:id])
    level = params[:level]
    category = Category.find_by(name: params[:category])
    demos = Demo.where(level: level, category: category, wad: @wad, guys: 1, tas: 0).reorder(:recorded_at)
    data_full = demos.all.map { |i| [i.players.first.username, i.tics, i.time, i.recorded_at] }
    if data_full.empty?
      render json: {data: [], players: [], error: true}
    end
    data_final = [data_full[0]]
    data_full.each do |datum|
      if datum[1] < data_final[-1][1]
        data_final.push(datum)
      end
    end
    plot = {data: [], players: {}, error: false}
    data_final.each do |datum|
      plot[:data].push({x: datum[3].to_s, y: datum[1]})
      plot[:players]["#{datum[1]}"] = datum[0]
    end
    render json: plot
  end
  
  def record_timeline
    @wad = Wad.find_by(username: params[:id])
    @level = params[:level]
    @category = params[:category]
  end
  
  private
  
    def wad_params
      params[:wad][:single_map] = (params[:wad][:single_map] == '1')
      params.require(:wad).permit(:name, :username, :author, :file, :iwad_username, :single_map)
    end
    
    # Allows destroy only for new items
    def age_limit
      @wad = Wad.find_by(username: params[:id])
      if @wad.is_frozen?
        flash[:warning] = "That Wad is too old to delete from here"
        redirect_to root_url
      end
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
