class DemosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create]
  before_action :authenticate_admin!, only: [:api_create]

  def feed
    @sort_sym = params[:sort_by] == 'record_date' ? :recorded_at : :updated_at
    @demos = Demo.reorder(@sort_sym => :desc).page params[:page]
  end

  def api_create
    preprocess_api_request(require: [:demo])
    demo = DemoCreationService.new(@request_hash[:demo]).create!
    render json: DemoSerializer.new(demo).call
  end

  def api_create
    parse_tags(demo_query['tags'])

  def hidden_tag
    demo = Demo.find(params[:id])
    render plain: demo.hidden_tags_text
  end
end
