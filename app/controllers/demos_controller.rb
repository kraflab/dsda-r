class DemosController < ApplicationController
  before_action :admin_session, except: :feed
  
  def feed
    @demos = Demo.reorder(created_at: :desc).paginate(page: params[:page])
  end
  
  def new
    @demo = Demo.new
    @demo.wad_username = params[:wad]
  end
  
  def create
    @demo = Demo.create(demo_params)
    if @demo.save
      flash[:info] = "Demo successfully created"
      redirect_to wad_path(@demo.wad)
    else
      render 'new'
    end
  end
  
  def destroy
  end
  
  def edit
    @demo = Demo.find(params[:id])
  end
  
  def update
  end
  
  private
    
    def demo_params
      params.require(:demo).permit(:name)
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to root_url
      end
    end
end
