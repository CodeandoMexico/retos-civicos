class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      authentication.update_attribute(:public_url, omniauth.info.urls.public_profile) if omniauth.provider == "linkedin" && !authentication.public_url.present?
      sign_in_and_redirect(authentication.user_id)
    elsif current_user
      current_user.authentications.create_with_omniauth(provider: omniauth['provider'], uid: omniauth['uid'])
      redirect_back_or root_url, t('auth_controller.new_auth')
    else
      @user = User.create_with_omniauth(omniauth)
      @user.authentications.first.update_attribute(:public_url, omniauth.info.urls.public_profile) if omniauth.provider == "linkedin" && !@user.authentications.first.public_url.present?
      sign_in_and_redirect(@user.id, true)
    end
  end

  def session_destroy
    session[:user_id] = nil
    redirect_to root_url, notice: t('auth_controller.destroy')
  end

  def failure
    redirect_to root_path, notice: t('auth_controller.failure')
  end

  private

  def sign_in_and_redirect(user_id, new_user = false)
    session[:user_id] = user_id
    if new_user
      redirect_to define_role_users_path, notice: t('auth_controller.define_role')
    else
      redirect_back_or challenges_path, t('auth_controller.sign_in')
    end
  end

end
