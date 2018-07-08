class DemosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create]
  before_action :authenticate_admin!, only: [:api_create]

  def feed
    @sort_sym = if params[:sort_by] == 'record_date'
                  :order_by_record_date
                else
                  :order_by_update
                end
    @demos = Domain::Demo.list(page: params[:page] || 1, @sort_sym => true)
  end

  def api_create
    preprocess_api_request(require: [:demo])
    demo = Domain::Demo.create(@request_hash[:demo])
    render json: DemoSerializer.new(demo).call
  end

  def hidden_tag
    demo = Domain::Demo.single(id: params[:id])
    render plain: demo.hidden_tags_text
  end
end
