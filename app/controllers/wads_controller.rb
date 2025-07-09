class WadsController < ApplicationController
  DEMO_RENDER_LIMIT = 1000

  skip_before_action :verify_authenticity_token, only: [:api_create, :api_update]
  before_action :authenticate_admin!, only: [:api_create, :api_update]

  ALLOWED_UPDATE_PARAMS = [
    :iwad,
    :file,
    :file_id,
    :name,
    :short_name,
    :author,
    :year,
    :compatibility,
    :is_commercial,
    :single_map,
    :parent
  ].freeze

  def index
    letter = params[:letter]
    if (/\A[a-z9]\z/ =~ letter) == 0
      if letter == '9'
        @wads = Domain::Wad.list(numbers: true)
      else
        @wads = Domain::Wad.list(letter: letter)
      end
    else
      @wads = Domain::Wad.list(page: params.fetch(:page, 1))
      @is_paginated = true
    end

    @wads = @wads.includes(:iwad)
  end

  def show
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
    @category = params[:category]
    @level = params[:level]

    @demos = Domain::Demo.list(
      wad_id: @wad.id, soft_category: @category
    )

    if @level.is_a?(String) && @level.include?('ILs')
      episode = @level.split(' ')[1].to_i
      @demos = @demos.episode(episode)
    elsif @level == 'Movies'
      @demos = @demos.show_movies
    elsif !@level.nil?
      @demos = @demos.where(level: @level)
    end

    if @demos.count > DEMO_RENDER_LIMIT && @level.nil? && @category.nil?
      @demos = @demos.where(level: @demos.ils.first.level)
    end

    @demos = @demos.includes(:players).includes(:demo_file)
  end

  def stats
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
  end

  def api_get
    wad = Domain::Wad.single(short_name: params[:id])
    render json: WadSerializer.new(wad, request.base_url).call
  end

  def api_create
    AdminAuthorizer.authorize!(@current_admin, :create)

    preprocess_api_request(require: [:wad])
    wad = Domain::Wad.create(**@request_hash[:wad])
    render json: WadSerializer.new(wad, request.base_url).call
  end

  def api_update
    AdminAuthorizer.authorize!(@current_admin, :update)

    preprocess_api_request(require: [:wad_update])
    wad = Domain::Wad.single(short_name: params[:id], assert: true)
    params = @request_hash[:wad_update].slice(*ALLOWED_UPDATE_PARAMS)
    Domain::Wad.update(**params.merge(id: wad.id))
    render json: WadSerializer.new(wad.reload, request.base_url).call
  end

  def record_timeline_json
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
    level = params[:level]
    category = params[:category]
    demos = Domain::Demo.list(
      wad_id: @wad.id, level: level, category: category, standard: true,
      order_by_record_date: :asc
    )
    data_full = demos.map { |i| [i.players.first.username, i.tics, i.time, i.recorded_at.to_date.to_s] }
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
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
    @level = params[:level]
    @category = params[:category]
  end

  def compare_movies_json
    wad = Domain::Wad.single(short_name: params[:id], assert: true)
    level = params[:level]
    category = params[:category]
    index_0 = params[:index_0].to_i
    index_1 = params[:index_1].to_i
    demos = Domain::Demo.list(
      level: level, category: category, wad_id: wad.id, standard: true
    )
    demo_0 = demos[index_0]
    demo_1 = demos[index_1]
    if level.nil? or !level.include?('Ep') or demo_0.nil? or demo_1.nil?
      render json: {error: true}
    end
    render json: {error: false,
                  times: compare_movies_pairs(demo_0, demo_1)}
  end

  def compare_movies
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
    @level = params[:level]
    @category = params[:category]
    @demos = Domain::Demo.list(
      level: @level, category: @category, wad_id: @wad.id, standard: true
    )
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

  def table_view
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
    @category = params[:category] || Domain::Category.list(iwad: @wad.iwad_short_name).first.name
    levels = Domain::Wad::TableLevelList.call(@wad, @category)
    @demos = Domain::Demo.standard_record_list(
      wad_id: @wad.id, levels: levels, category: @category, very_soft: true
    )
  end

  def leaderboard
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
    @category = params[:category] || Domain::Category.list(iwad: @wad.iwad_short_name).first.name
    @level = params[:level] || @wad.demos.ils.first.level
    @demos = Domain::Demo.list(
      wad_id: @wad.id, soft_category: @category, level: @level, standard: true
    ).to_a.sort_by { |d| d.tics }.uniq { |d| d.players.first.id }
  end

  def history
    @wad = Domain::Wad.single(short_name: params[:id], assert: true)
    @category = params[:category]
    @level = params[:level]
    @demos = Domain::Demo.list(
      wad_id: @wad.id, soft_category: @category
    )

    if @level.is_a?(String) && @level.include?('ILs')
      episode = @level.split(' ')[1].to_i
      @demos = @demos.episode(episode)
    elsif @level == 'Movies'
      @demos = @demos.show_movies
    elsif !@level.nil?
      @demos = @demos.where(level: @level)
    end

    @demos = @demos.includes(:players)
                    .includes(:demo_file)
                    .includes(:wad)
                    .reorder(Arel.sql('recorded_at DESC NULLS LAST'))
                    .order('wads.short_name', :level, :category_id, :tics)
                    .page(params[:page])
  end
end
