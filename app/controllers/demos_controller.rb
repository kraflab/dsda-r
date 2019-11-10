class DemosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create, :api_update]
  before_action :authenticate_admin!, only: [:api_create, :api_update]

  ALLOWED_UPDATE_PARAMS = [
    :time,
    :category,
    :wad,
    :level,
    :tas,
    :guys,
    :players,
    :video_link,
    :levelstat,
    :recorded_at,
    :engine,
    :kills,
    :items,
    :secrets,
    :solo_net,
    :tags
  ].freeze

  def feed
    sort_key, @sort_field = if params[:sort_by] == 'record_date'
                              [:order_by_record_date, :recorded_at]
                            else
                              [:order_by_id, :created_at]
                            end
    @demos = Domain::Demo.list(page: params[:page] || 1, sort_key => :desc)
               .includes(:players).includes(:category).includes(:demo_file)
               .includes(wad: :iwad)
  end

  def api_create
    preprocess_api_request(require: [:demo])
    demo = Domain::Demo.create(@request_hash[:demo])
    render json: DemoSerializer.new(demo).call
  end

  def api_update
    preprocess_api_request(require: [:demo_update])
    demo = find_match(@request_hash[:demo_update][:match_details])
    params = @request_hash[:demo_update].slice(*ALLOWED_UPDATE_PARAMS)
    Domain::Demo.update(params.merge(id: demo.id))
    render json: DemoSerializer.new(demo).call
  end

  def record
    wad = Domain::Wad.single(short_name: params[:wad])
    demo = wad.present? && Domain::Demo.standard_record(
      wad_id: wad.id,
      level: params[:level],
      category: params[:category]
    )
    render json: RecordSerializer.call(demo, wad, request.base_url)
  end

  def hidden_tag
    demo = Domain::Demo.single(id: params[:id], assert: true)
    render plain: demo.hidden_tags_text
  end

  private

  def find_match(details)
    matches = Domain::Demo.find_matches(details)

    raise Errors::NoMatches if matches.count == 0
    raise Errors::TooManyMatches if matches.count > 1

    matches.first
  end
end
