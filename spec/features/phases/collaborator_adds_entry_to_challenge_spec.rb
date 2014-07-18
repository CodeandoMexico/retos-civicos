require 'spec_helper'

feature 'Collaborator adds entry to challenge' do
  scenario 'on the ideas phase' do
    member = create :member
    challenge = create :challenge, ideas_phase_due_on: 2.weeks.from_now
    create :collaboration, member: member, challenge: challenge

    sign_in_user member
    visit new_challenge_entry_path(challenge)

    submit_entry_form_with(
      project_name: 'Mi super app',
      description: 'Es la mejor',
      idea_url: 'https://github.com/CodeandoMexico/aquila',
      technologies: 'Ruby, Haskell, Elixir, Rust',
      image: app_image,
      letter_under_oath: entry_pdf
    )

    current_path.should eq challenge_path(challenge)
    page.should have_content success_message(2.weeks.from_now)
  end

  scenario 'but fails because there is not a valid idea url' do
    member = create :member
    challenge = create :challenge, ideas_phase_due_on: 2.weeks.from_now
    create :collaboration, member: member, challenge: challenge

    sign_in_user member
    visit new_challenge_entry_path(challenge)

    submit_entry_form_with(
      project_name: 'Mi super app',
      description: 'Es la mejor',
      idea_url: 'esteesunurlinvalido',
      technologies: 'Ruby, Haskell, Elixir, Rust',
      image: app_image,
      letter_under_oath: entry_pdf
    )

    current_path.should eq challenge_entries_path(challenge)
    page.should have_content 'Link a la propuesta es inválido'
  end

  scenario 'but fails because ideas phase is due' do
    member = create :member
    challenge = create :challenge, ideas_phase_due_on: 2.weeks.ago

    sign_in_user(member)

    visit challenge_path(challenge)
    page.should_not have_link 'Envía tu propuesta'

    visit new_challenge_entry_path(challenge)
    current_path.should eq challenge_path(challenge)
  end

  describe 'when just one challenge exists' do
    scenario 'it registers and then creates the entry' do
      challenge = create :challenge, title: 'Reto 1', ideas_phase_due_on: 2.weeks.from_now

      visit challenge_path(challenge)
      click_link 'Regístrate al reto aquí'

      submit_registration_form('juanito@example.com')
      click_link('Reto 1')
      click_link('Envía tu propuesta')
      submit_entry_form_with(
        project_name: 'Mi super app',
        description: 'Es la mejor',
        idea_url: 'https://github.com/CodeandoMexico/aquila',
        technologies: 'Ruby, Haskell, Elixir, Rust',
        image: app_image,
        letter_under_oath: entry_pdf
      )

      page.should have_content success_message(2.weeks.from_now)
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
    fill_in 'entry_idea_url', with: args.fetch(:idea_url)
    args.fetch(:technologies).split(", ").each do |tech|
      select tech, from: 'entry_technologies'
    end
    attach_file 'entry_letter_under_oath', args.fetch(:letter_under_oath)
    attach_file 'entry_image', args.fetch(:image)
    click_button 'Enviar proyecto'
  end

  def success_message(date)
    "Has enviado tu propuesta con éxito. Podrás editarla hasta #{I18n.l(date.to_date, format: :long)}"
  end
end
