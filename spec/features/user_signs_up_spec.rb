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
      # page.should have_link('Juanito')
      expect(page).to have_link 'Juanito'
    end
  end

  describe 'when just one challenge exists' do
    before do
      reset_email
      create :challenge, welcome_mail: { subject: 'Bienvenido al reto', body: 'Hola' }
    end

    scenario 'with email and password' do
      Capybara.using_driver :selenium do
        visit_registration_form
        submit_registration_form('juanito@example.com')
        submit_profile_form('Juanito')
        click_link 'Envía tu propuesta'
        submit_entry_form_with(
          project_name: 'Mi super app',
          description: 'Es la mejor',
          idea_url: 'https://github.com/CodeandoMexico/aquila',
          technologies: 'Ruby, Haskell, Elixir, Rust',
          image: "#{Rails.root}/spec/images/happy-face.jpg"
        )

        mail_for_collaboration_should_be_sent_to('juanito@example.com')
        end
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
    fill_in 'user_email', with: email
    fill_in 'user_password', with: 'secret'
    fill_in 'user_password_confirmation', with: 'secret'
    click_button 'Registrarme'
  end

  def submit_profile_form(name)
    fill_in 'member_name', with: name
    click_button 'Actualizar'
  end

  def submit_entry_form_with(args)
    fill_in 'entry_name', with: args.fetch(:project_name)
    fill_in 'entry_description', with: args.fetch(:description)
    fill_in 'entry_idea_url', with: args.fetch(:idea_url)
    args.fetch(:technologies).split(', ').each do |tech|
      select tech, from: 'entry_technologies'
    end
    attach_file 'entry_image', args.fetch(:image)
    click_button 'Enviar proyecto'
  end
end
