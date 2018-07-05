class IwadsController < ApplicationController
  def index
    @iwads = Domain::Iwad.list
  end

  def show
    @iwad = Domain::Iwad.single(short_name: params[:id])
    @wads = @iwad.wads
  end

  def stats
    @iwad = Domain::Iwad.single(short_name: params[:id])
  end
end
