class StaticPagesController < ApplicationController
  def home
  end

  def stats
  end

  def about
  end

  def search
    @search = params[:search]
    @players = Player.where('username LIKE ?', "%#{@search}%")
    @wads = Wad.where('username LIKE ?', "%#{@search}%")
  end

  def no_file
  end
end
