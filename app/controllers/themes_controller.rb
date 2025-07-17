class ThemesController < ApplicationController
  def set
    theme = params[:theme]

    if themes.include?(theme)
      cookies.permanent[:theme] = theme
    end

    redirect_back(fallback_location: root_path)
  end
end
