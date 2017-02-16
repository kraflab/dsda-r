class DemosController < ApplicationController
  
  def feed
    @demos = Demo.reorder(created_at: :desc).paginate(page: params[:page])
  end
end
