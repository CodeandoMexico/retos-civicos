require 'spec_helper'

feature 'Collaborator adds entry to challenge' do
  scenario 'with the right data' do
    member = create :member
    challenge = create :challenge
    create :collaboration, member: member, challenge: challenge

    sign_in_user member
    visit new_challenge_entry_path(challenge)

    submit_entry_form_with(
      project_name: 'Mi super app',
      description: 'Es la mejor',
      url: 'https://github.com/CodeandoMexico/aquila',
      technologies: 'Ruby, Haskell, Elixir, Rust',
      image: app_image,
      proposal: entry_pdf
    )

    page.should have_content entry_create_successfully
  end

  describe 'when just one challenge exists' do
    scenario 'it registers and then creates the entry' do
      challenge = create :challenge

      visit challenge_path(challenge)
      click_link 'Regístrate al reto aquí'

      submit_registration_form('juanito@example.com')
      submit_profile_form('Juanito')
      submit_entry_form_with(
        project_name: 'Mi super app',
        description: 'Es la mejor',
        url: 'https://github.com/CodeandoMexico/aquila',
        technologies: 'Ruby, Haskell, Elixir, Rust',
        image: app_image,
        proposal: entry_pdf
      )

      page.should have_content entry_create_successfully
    end
  end

  def app_image
    "#{Rails.root}/spec/images/happy-face.jpg"
  end

  def entry_pdf
    "#{Rails.root}/spec/fixtures/dummy.pdf"
  end

  def entry_create_successfully
    'Gracias por tu propuesta'
  end

  def submit_profile_form(name)
    fill_in 'member_name', with: name
    click_button 'Actualizar'
  end

  def submit_registration_form(email)
      click_link 'Inicia con Email'
      click_link 'Regístrate aquí'
      fill_in 'user_email', with: 'juanito@example.com'
      fill_in 'user_password', with: 'secret'
      fill_in 'user_password_confirmation', with: 'secret'
      click_button 'Registrarme'
  end

  def submit_entry_form_with(args)
    fill_in 'entry_name', with: args.fetch(:project_name)
    fill_in 'entry_description', with: args.fetch(:description)
    fill_in 'entry_live_demo_url', with: args.fetch(:url)

    args.fetch(:technologies).split(", ").each do |tech|
      select tech, from: 'entry_technologies'
    end

    attach_file 'entry_proposal_file', args.fetch(:proposal)
    attach_file 'entry_image', args.fetch(:image)
    click_button 'Enviar proyecto'
  end
end
