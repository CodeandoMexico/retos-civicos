require 'spec_helper'

feature 'Collaborator adds entry to challenge' do
  scenario 'on the ideas phase' do
    member = create :member
    challenge = create :challenge, ideas_phase_due_on: Date.new(2014,11,2)
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

    current_path.should eq challenge_path(challenge)
    page.should have_content success_message
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
    args.fetch(:technologies).split(", ").each do |tech|
      select tech, from: 'entry_technologies'
    end
    attach_file 'entry_image', args.fetch(:image)
    click_button 'Enviar proyecto'
  end

  def success_message
    "Has enviado la propuesta de la primer etapa con éxito. Podrás editarla hasta noviembre 02, 2014"
  end
end
