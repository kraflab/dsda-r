class StaticPagesController < ApplicationController
  RECORD_INDEX_LIMIT = 50

  def home
  end

  def stats
    @record_index_players =
      Domain::Player.list(by_record_index: true, limit: RECORD_INDEX_LIMIT)
  end

  def about
  end

  def search
    @search = params[:search]
    @iwads = Domain::Iwad.search(term: @search)
    @players = Domain::Player.search(term: @search)
    @wads = Domain::Wad.search(term: @search)

    if @iwads.count == 1 && @players.count == 0 && @wads.count == 0
      redirect_to iwad_url(@iwads.first)
    elsif @players.count == 1 && @iwads.count == 0 && @wads.count == 0
      redirect_to player_url(@players.first)
    elsif @wads.count == 1 && @iwads.count == 0 && @players.count == 0
      redirect_to wad_url(@wads.first)
    end
  end

  def no_file
  end

  def intro
  end

  def changelog
  end

  def stream
  end

  def advice
  end

  def not_found
  end
end
