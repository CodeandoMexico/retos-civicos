require 'spec_helper'

feature 'User signs up' do
  describe 'with more than one challenge' do
    before do
      create_list :challenge, 2
    end

    scenario 'with email and password' do
      visit_registration_form
      submit_registration_form('juanito@example.com')
      submit_profile_form('Juanito')
      page.should have_link('Regístrate al reto aquí')
    end
  end

  describe 'when just one challenge exists' do
    before do
      reset_email
      create :challenge, welcome_mail: { subject: 'Bienvenido al reto', body: 'Hola' }
    end

    scenario 'with email and password' do
      visit_registration_form
      submit_registration_form('juanito@example.com')
      submit_profile_form('Juanito')
      page.should have_link('Envía tu propuesta')
      mail_for_collaboration_should_be_sent_to('juanito@example.com')
    end
  end

  def mail_for_collaboration_should_be_sent_to(email_address)
    ActionMailer::Base.deliveries.select do |email|
      email.subject == 'Bienvenido al reto'
    end.first.to.should include email_address
  end

  def visit_registration_form
    visit '/registrate'
    click_link 'Inicia con Email'
    click_link 'Regístrate aquí'
  end

  def submit_registration_form(email)
    fill_in 'user_email', with: 'juanito@example.com'
    fill_in 'user_password', with: 'secret'
    fill_in 'user_password_confirmation', with: 'secret'
    click_button 'Registrarme'
  end

  def submit_profile_form(name)
    fill_in 'member_name', with: name
    click_button 'Actualizar'
  end
end
