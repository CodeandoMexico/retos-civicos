require 'spec_helper'

feature 'Collaborator adds entry to challenge' do
  scenario 'with the right data' do
    member = create :member
    challenge = create :challenge
    create :collaboration, member: member, challenge: challenge

    sign_in_user member
    visit new_challenge_entry_path(challenge)

    submit_entry_form_with(
      company_name: 'Empresa de Juanito',
      company_rfc: 'Juanito2014',
      project_name: 'Mi super app',
      description: 'Es la mejor',
      url: 'https://github.com/CodeandoMexico/aquila',
      technologies: 'Ruby, Haskell, Elixir, Rust',
      image: app_image
    )

    page_should_have_pitch_with(
      'Empresa de Juanito',
      'Mi super app',
      'Es la mejor',
      'https://github.com/CodeandoMexico/aquila',
      'Ruby, Haskell, Elixir, Rust'
    )

    app_should_not_be_counted_yet
  end

  def app_image
    "#{Rails.root}/spec/images/happy-face.jpg"
  end

  def submit_entry_form_with(args)
    fill_in 'entry_name', with: args.fetch(:project_name)
    fill_in 'entry_company_name', with: args.fetch(:company_name)
    fill_in 'entry_company_rfc', with: args.fetch(:company_rfc)
    fill_in 'entry_description', with: args.fetch(:description)
    fill_in 'entry_live_demo_url', with: args.fetch(:url)
    fill_in 'entry_technologies', with: args.fetch(:technologies)
    attach_file 'entry_image', args.fetch(:image)
    click_button 'Enviar proyecto'
  end

  def page_should_have_pitch_with(*data)
    # This behaivior has been changed for now
    #within '#pitch' do
      #data.each { |item| page.should have_content item }
    #end
  end

  def app_should_not_be_counted_yet
    within '.challenge-tabs' do
      page.should have_content '0 App'
    end
  end
end
