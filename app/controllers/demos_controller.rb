class DemosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create, :api_update, :api_delete]
  before_action :authenticate_admin!, only: [:api_create, :api_update, :api_delete]
  before_action :verify_otp!, only: :api_delete

  ALLOWED_UPDATE_PARAMS = [
    :time,
    :category,
    :wad,
    :level,
    :tas,
    :cheated,
    :suspect,
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
    :tags,
    :secret_exit
  ].freeze

  def feed
    sort_key, @sort_field = if params[:sort_by] == 'record_date'
                              [:recorded_at, :recorded_at]
                            else
                              [:id, :created_at]
                            end
    @page = params[:page]
    @demos = Domain::Demo.list(page: @page || 1, order_by: sort_key, order_direction: :desc)
               .includes(:players).includes(:category).includes(:demo_file)
               .includes(wad: :iwad)
  end

  def api_create
    AdminAuthorizer.authorize!(@current_admin, :create)

    preprocess_api_request(require: [:demo])
    demo = Domain::Demo.create(**@request_hash[:demo])
    render json: DemoSerializer.new(demo, request.base_url).call
  end

  def api_update
    AdminAuthorizer.authorize!(@current_admin, :update)

    preprocess_api_request(require: [:demo_update])
    demo = find_demo
    params = @request_hash[:demo_update].slice(*ALLOWED_UPDATE_PARAMS)
    Domain::Demo.update(**params.merge(id: demo.id))
    render json: DemoSerializer.new(demo.reload, request.base_url).call
  end

  def api_delete
    AdminAuthorizer.authorize!(@current_admin, :delete)

    preprocess_api_request(require: [:demo_delete])
    Domain::Demo.delete(id: find_by_details.id)
    render json: { success: true }, status: :ok
  end

  def api_records
    wad = Domain::Wad.single(short_name: params[:wad])
    demo = wad.present? && Domain::Demo.standard_record(
      wad_id: wad.id,
      level: params[:level],
      category: params[:category]
    )
    render json: RecordSerializer.call(demo, wad, request.base_url)
  end

  def api_get
    demo = Domain::Demo.single(id: params[:id])
    render json: DemoSerializer.call(demo, request.base_url)
  end

  def api_demos
    wad = Domain::Wad.single(short_name: params[:wad])
    level = params[:level]
    category = params[:category]
    only_records = params[:only_records] && ActiveModel::Type::Boolean.new.cast(params[:only_records])

    order_param = params[:sort_by] || 'time:asc'
    order_by, order_direction = order_param.split(':')
    if order_by == 'date'
      order_by = :recorded_at
    elsif order_by == 'id'
      order_by = :id
    else
      order_by = :tics
    end
    order_direction = order_direction&.downcase == 'desc' ? :desc : :asc

    page = params[:page] || 1
    per = params[:per] || 50
    per = 200 if per.to_i > 200

    demos = Domain::Demo.list(wad_id: wad&.id, level: level, category: category,
                              only_records: only_records,
                              page: page, per: per, order_by: order_by, order_direction: order_direction)
                        .includes(:players).includes(:category).includes(:demo_file)
                        .includes(wad: :iwad)

    render json: {
      demos: demos.map { |demo| DemoSerializer.call(demo, request.base_url) },
      page: page,
      per: per,
      total_pages: demos.total_pages,
      total_demos: demos.total_count
    }
  end

  def hidden_tag
    demo = Domain::Demo.single(id: params[:id], assert: true)
    render plain: demo.hidden_tags_text
  end

  private

  def find_demo
    if match_details[:id]
      find_by_id
    else
      find_by_details
    end
  end

  def match_details
    (@request_hash[:demo_update] || @request_hash[:demo_delete])[:match_details]
  end

  def find_by_id
    demo = ::Domain::Demo.single(id: match_details[:id])
    return demo if demo

    raise Errors::NoMatches
  end

  def find_by_details
    matches = Domain::Demo.find_matches(match_details)

    raise Errors::NoMatches if matches.count == 0
    raise Errors::TooManyMatches if matches.count > 1

    matches.first
  end
end
