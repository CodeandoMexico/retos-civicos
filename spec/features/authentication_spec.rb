require 'spec_helper'

feature 'User logs in with omniauth' do

  scenario 'using Twitter' do
    visit root_path
    click_on 'Inicia sesión'
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    Rails.application.env_config["omniauth.auth"].stub(:provider) { "twitter" }
    Rails.application.env_config["omniauth.auth"].stub(:uid) { "25073877" }
    Rails.application.env_config["omniauth.auth"].stub_chain(:info, :name).and_return("Javier")
    Rails.application.env_config["omniauth.auth"].stub_chain(:info, :nickname).and_return("Javi")
    click_on 'Inicia con Twitter'
    Authentication.last.uid.should == '25073877'
    page.should have_content "Confirma tu correo antes de iniciar tu participación"
    page.should have_content "Editar perfil"
    page.should have_content "Javier"
  end
end
