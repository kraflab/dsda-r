class IwadsController < ApplicationController
  def index
    @iwads = Iwad.all
  end

  def show
    @iwad = Iwad.find_by(username: params[:id])
    @wads = @iwad.wads
  end

  def stats
    @iwad = Iwad.find_by(username: params[:id])
  end
end
