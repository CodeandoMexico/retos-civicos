class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      sign_in_and_redirect(authentication.user_id)
    elsif current_user
      current_user.authentications.create!(provider: omniauth['provider'], uid: omniauth['uid'])
      redirect_to root_url, notice: "New authentication successful."
    else
      user = User.create_with_omniauth(omniauth)
      sign_in_and_redirect(user.id)
    end
  end

  def session_destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out successfully."
  end

  def failure
    redirect_to root_path, notice: "Authentication not authorized"
  end

  private

  def sign_in_and_redirect(user_id)
    session[:user_id] = user_id
    redirect_to root_path, notice: "Signed in successfully."
  end

end
