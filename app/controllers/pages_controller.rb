class PagesController < ApplicationController
  layout 'aquila'

  def sign_up
    @omniauth_providers = User.omniauth_providers
    render layout: 'aquila'
  end

  def set_language
    locale = session[:locale] = params[:i18n][:locale]
    route = Rails.application.routes.recognize_path(request.referer)
    route[:locale] = locale.to_s
    redirect_to url_for(route)
  end

  def start_a_challenge
    render layout: 'aquila'
  end

  def about
    render layout: 'aquila'
  end

  def terms_of_service
    render layout: 'aquila'
  end

  def privacy
    render layout: 'aquila'
  end

  def jobs
  end
end
