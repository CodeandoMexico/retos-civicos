class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    store_location(self.request.env["HTTP_REFERER"])
    redirect_to signup_path, :alert => t('flash.unauthorized.message')
  end

  def set_locale
    I18n.locale = session[:locale] || "es"
  end

  def after_sign_in_path_for(resource)
    if resource.organization?
      organization = resource.userable
      return dashboard_url(subdomain: organization.subdomain)
    end

    if resource.just_created?
      edit_current_user_path(resource.userable)
    else
      session[:return_to] || challenges_path
    end
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

  private

  def clear_return_to
    session.delete(:return_to)
  end
end
