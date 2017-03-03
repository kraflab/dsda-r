class SessionsController < ApplicationController
  def new
  end
  
  def create
    admin = Admin.find_by(username: params[:session][:username])
    if admin
      if admin.fail_count >= 5
        flash[:danger] = "This account has been locked; contact kraflab"
        redirect_to root_url
      elsif admin.authenticate(params[:session][:password])
        log_in admin
        flash[:info] = 'You are now logged in'
        redirect_to root_path
      else
        admin.reload.fail_count += 1
        admin.save
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
  
  def settings
  end
  
  def set
    Iwad.all.each do |iwad|
      cookies.permanent["iwad:#{iwad.id}"] = params["iwad:#{iwad.id}"]
    end
    flash.now[:info] = 'Your settings have been updated'
    render 'settings'
  end
end
