class AdminsController < ApplicationController
  before_action :admin_session
  
  def edit
    @admin = current_admin
  end
  
  def update
    @admin = current_admin
    if @admin && @admin.authenticate(admin_params[:current_password])
      if @admin.update_attributes(admin_params.permit(:password,
                                                      :password_confirmation))
        flash[:info] = 'Password successfully updated'
        redirect_to root_path
      else
        render 'edit'
      end
    else
      flash.now[:warning] = 'Incorrect password'
      render 'edit'
    end
  end
  
  private
  
    def admin_params
      params.require(:admin).permit(:current_password, :password,
                                    :password_confirmation)
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = 'You must be logged in to perform this action'
        redirect_to(root_url)
      end
    end
end
