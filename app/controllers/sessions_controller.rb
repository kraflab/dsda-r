class SessionsController < ApplicationController
  def new
  end
  
  def create
    admin, code = authenticate_admin(params[:session][:username],
                                     params[:session][:password])
    if admin
      case code
      when ADMIN_ERR_LOCK
        flash[:danger] = "This account has been locked; contact kraflab"
        redirect_to root_url
      when ADMIN_SUCCESS
        log_in admin
        flash[:info] = 'You are now logged in'
        redirect_to root_path
      when ADMIN_ERR_FAIL
        flash.now[:danger] = 'Invalid username/password combination'
        render 'new'
      end
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    flash[:info] = 'You are now logged out'
    redirect_to root_url
  end
  
  def category_filter
    render json: cookies["category_filter"]
  end
  
  def settings
    cookies.permanent["category_filter"] ||= '{"filter": [], "hideTas": false, "hideCoop": false}'
  end
  
  def set
    category_filter = {filter: [], hideTas: false, hideCoop: false}
    Category.all.each do |category|
      category_filter[:filter].push(category.name) if params["cat:#{category.name}"] == "0"
    end
    category_filter[:hideTas] = params["hideTas"] == "0"
    category_filter[:hideCoop] = params["hideCoop"] == "0"
    cookies.permanent["category_filter"] = category_filter.to_json
    flash.now[:info] = 'Your settings have been updated'
    render 'settings'
  end
end
