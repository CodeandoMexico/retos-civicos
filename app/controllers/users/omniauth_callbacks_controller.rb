class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    @auth = Authentication.find_for_provider_oauth(request.env["omniauth.auth"], current_user)

    if @auth.persisted?
      user = @auth.user
      sign_in user
      redirect_after_sign_in_with_oauth_for(user)
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

   alias_method :github, :all
   alias_method :linkedin, :all

   private

   def redirect_after_sign_in_with_oauth_for(user)
     if user.just_created?
       redirect_to edit_current_user_path(user.userable), notice: t('omniauth_controller.last_step')
     else
       redirect_back_or(challenges_path, t('omniauth_controller.welcome_back', provider: @auth.provider.capitalize))
     end
   end

end
