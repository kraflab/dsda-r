class CookiesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:accept, :theme]

  def accept
    cookies.permanent[:accept] = 'true'
    redirect_back(fallback_location: root_path)
  end

  def theme
    theme = params[:theme]

    if cookies[:accept] == 'true' && themes.include?(theme)
      cookies.permanent[:theme] = theme
    end

    redirect_back(fallback_location: root_path)
  end
end
