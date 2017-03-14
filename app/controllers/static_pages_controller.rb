class StaticPagesController < ApplicationController
  def home
  end
  
  def stats
  end
  
  def tools
  end
  
  def about
  end
  
  def search
    @search = params[:search]
  end
end
