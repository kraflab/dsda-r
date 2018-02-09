class WadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create]

  def index
    letter = params[:letter]
    if (/\A[a-z9]\z/ =~ letter) == 0
      if letter == '9'
        @wads = Rails.env.production? ?
          Wad.where('username ~ ?', '^[0-9]') :
          Wad.where('username REGEXP ?', '^[0-9]')
      else
        @wads = Wad.where('username LIKE ?', "#{letter}%")
      end
    else
      @wads = Wad.page params[:page]
      @is_paginated = true
    end
  end

  def show
    @wad = Wad.find_by!(username: params[:id])
    subset = params[:level]
    if subset.is_a?(String) && subset.include?('Episode')
      episode = subset.split(' ').last.to_i
      @demos = @wad.demos.episode(episode)
    else
      @demos = subset.nil? ? @wad.demos : @wad.demos.where(level: subset)
    end
  end

  def stats
    @wad = Wad.find_by(username: params[:id])
  end

  def api_create
    query = preprocess_api_authenticate(request)
    render json: WadCreationService.new(query['wad']).create
  end

  def record_timeline_json
    @wad = Wad.find_by(username: params[:id])
    level = params[:level]
    category = Category.find_by(name: params[:category])
    demos = Demo.where(level: level, category: category, wad: @wad, guys: 1, tas: 0).reorder(:recorded_at)
    data_full = demos.all.map { |i| [i.players.first.username, i.tics, i.time, i.recorded_at] }
    if data_full.empty?
      render json: {data: [], players: [], error: true}
    else
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
  end

  def record_timeline
    @wad = Wad.find_by(username: params[:id])
    @level = params[:level]
    @category = params[:category]
  end

  def compare_movies_json
    wad = Wad.find_by(username: params[:id])
    level = params[:level]
    category = params[:category]
    index_0 = params[:index_0].to_i
    index_1 = params[:index_1].to_i
    demos = Demo.where(level: level, category: Category.find_by(name: category), wad: wad, guys: 1, tas: 0)
    demo_0 = demos[index_0]
    demo_1 = demos[index_1]
    if level.nil? or !level.include?('Ep') or demo_0.nil? or demo_1.nil?
      render json: {error: true}
    end
    render json: {error: false,
                  times: compare_movies_pairs(demo_0, demo_1)}
  end

  def compare_movies
    @wad = Wad.find_by(username: params[:id])
    @level = params[:level]
    @category = params[:category]
    @demos = Demo.where(level: @level, category: Category.find_by(name: @category), wad: @wad, guys: 1, tas: 0)
    if @level.nil? or !@level.include?('Ep') or @demos.count < 2
      if @wad.nil?
        flash[:info] = 'Wad not found'
        redirect_to root_url
      else
        flash[:info] = 'A movie comparison is not possible for these parameters'
        redirect_to wad_url(@wad)
      end
    end
  end
end
