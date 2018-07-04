class StaticPagesController < ApplicationController
  RECORD_INDEX_LIMIT = 20

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
    @wads = Wad.where('username LIKE ?', "%#{@search}%")
  end

  def no_file
  end
end
