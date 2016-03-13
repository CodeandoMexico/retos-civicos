class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    Rails.logger.debug(request.env['omniauth.auth'])

    @auth = Authentication.find_for_provider_oauth(request.env['omniauth.auth'], current_user)

    if @auth.persisted?
      sign_in @auth.user
      Collaborations.create_after_registration(current_member)
      redirect_after_sign_in_with_oauth_for(@auth.user)
    else
      session['devise.omniauth_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  alias github :all
  alias linkedin :all
  alias twitter :all
  alias facebook :all

  private

  def redirect_after_sign_in_with_oauth_for(user)
    if user.just_created?
      redirect_to edit_current_user_path(user.userable), notice: t('omniauth_controller.last_step')
    elsif user.email.blank?
      redirect_to edit_current_user_path(user.userable), notice: t('omniauth_controller.confirm_email')
    else
      welcome_back_text = t('omniauth_controller.welcome_back', provider: @auth.provider.capitalize)
      redirect_back_or(challenges_path, welcome_back_text)
    end
  end
end
