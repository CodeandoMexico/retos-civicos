class HomeController < ApplicationController
  
  layout "home"

  def index
    @projects = Project.limit(3)
  end

  def sign_up 
  end

  def set_language
    session[:locale] = params[:locale]
    redirect_to :back
  end
end
