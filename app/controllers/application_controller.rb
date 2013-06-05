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

  def redirect_on_sign_in_path
    if current_user.just_created?
      redirect_to define_role_users_path, notice: t('auth_controller.define_role')
    else
      redirect_back_or challenges_path, t('auth_controller.sign_in')
    end
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

  def load_organization
    @organization = Organization.find_by_subdomain!(request.subdomain)
  end
end


