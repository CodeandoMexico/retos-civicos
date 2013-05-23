class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def set_locale
    I18n.locale = session[:locale] || "es"
  end

  private


  def authorize_user!
    redirect_to sign_up_path, flash: { error: t('app_controller.login_required') } unless user_signed_in?
  end

  def save_location
    store_location unless user_signed_in?
  end

  def save_previous
    store_location(request.referer) unless user_signed_in?
  end
end


