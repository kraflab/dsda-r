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
    @players = Domain::Player.search(term: @search)
    @wads = Domain::Wad.search(term: @search)

    if @players.count == 1 && @wads.count == 0
      redirect_to player_url(@players.first)
    elsif @wads.count == 1 && @players.count == 0
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
end
