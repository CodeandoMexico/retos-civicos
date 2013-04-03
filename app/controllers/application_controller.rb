class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  helper_method :current_user, :signed_in?

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def set_locale
    I18n.locale = session[:locale] || "es"
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  def authorize_user!
    redirect_to sign_up_path, flash: { error: t('app_controller.login_required') } unless signed_in?
  end

  def save_location
    store_location unless signed_in?
  end

  def save_previous
    store_location(request.referer) unless signed_in?
  end
end
