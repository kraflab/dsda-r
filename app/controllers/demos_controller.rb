class DemosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create]
  before_action :authenticate_admin!, only: [:api_create]

  def feed
    sort_key, @sort_field = if params[:sort_by] == 'record_date'
                              [:order_by_record_date, :recorded_at]
                            else
                              [:order_by_id, :created_at]
                            end
    @demos = Domain::Demo.list(page: params[:page] || 1, sort_key => :desc)
  end

  def api_create
    preprocess_api_request(require: [:demo])
    demo = Domain::Demo.create(@request_hash[:demo])
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
end
