class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery
  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    store_location(self.request.env["HTTP_REFERER"])
    redirect_to signup_path, :alert => t('flash.unauthorized.message')
  end

  def set_locale
    I18n.locale = session[:locale] || "es"
  end

  def after_sign_in_path_for(resource)
    return dashboard_url if resource.organization?
    return edit_current_user_path(resource.userable) if resource.just_created?
    session[:return_to] || challenges_path
  end

  def redirect_back_or(default, notice)
    redirect_to((session[:return_to] || default), notice: notice)
    clear_return_to
  end

  def store_location(url = request.fullpath)
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/login" && (request.fullpath != "/logout" && !request.xhr?)) # don't store ajax calls
      session[:return_to] = url
    end
    session[:return_to] = url
  end

  def last_challenge
    @last_challenge ||= Challenge.order('created_at desc').first
  end

  helper_method :last_challenge

  private

  def clear_return_to
    session.delete(:return_to)
  end
end
