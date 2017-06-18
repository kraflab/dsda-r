class SessionsController < ApplicationController
  def new
  end

  def create
    admin, code = authenticate_admin(params[:session][:username],
                                     params[:session][:password])
    if admin
      case code
      when ADMIN_ERR_LOCK
        flash[:danger] = 'This account has been locked; contact kraflab'
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

  def settings
    cookies.permanent['demo_filter'] ||= '{"category": [], "tas": false, "coop": false, "port": []}'
  end

  def set
    demo_filter = {category: [], tas: false, coop: false, port: []}
    Category.all.each do |category|
      demo_filter[:category].push(category.name) if params["cat:#{category.name}"] == '0'
    end
    demo_filter[:tas] = params['tas'] == '0'
    demo_filter[:coop] = params['coop'] == '0'
    demo_filter[:port].push('vanilla') if params['port:vanilla'] == '0'
    demo_filter[:port].push('compatible') if params['port:compatible'] == '0'
    demo_filter[:port].push('incompatible') if params['port:incompatible'] == '0'
    cookies.permanent['demo_filter'] = demo_filter.to_json
    flash.now[:info] = 'Your settings have been updated'
    render 'settings'
  end

  private

    # Logs in the given admin
    def log_in(admin)
      session[:username] = admin.username
      admin.fail_count = 0
      admin.save
    end

    # Logs out the current admin
    def log_out
      session.delete(:username)
      @current_admin = nil
    end
end
