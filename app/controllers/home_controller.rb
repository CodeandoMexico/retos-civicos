class HomeController < ApplicationController
  
  layout "home"

  def index
    @projects = Project.limit(3)
  end

  def sign_up 
  end

  def set_language
    locale = session[:locale] = params[:i18n][:locale]
    route = Rails.application.routes.recognize_path(request.referer)
    route.merge!({locale: locale.to_s})

    redirect_to url_for(route)
  end

end
