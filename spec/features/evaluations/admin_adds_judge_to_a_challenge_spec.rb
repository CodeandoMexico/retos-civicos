require 'spec_helper'

feature 'Admin tries to add a judge to a challenge and' do
  attr_reader :organization, :challenge

  before do
    @organization = create :organization
    @challenge = create :challenge, organization: organization
    sign_in_organization_admin(organization.admin)
  end

  scenario 'and the judge already exists and has NO previous evaluations' do
    email = 'judge_already_exist@email.com'
    judge = create :judge, email: email

    add_judge_to_challenge_with(email: email)

    expect(page).to have_content I18n.t('dashboard.evaluations.show.title', name: judge.name)
    click_button 'Acepto'

    expect(page).to have_content 'El juez ha sido invitado a evaluar el reto.'
    expect(page).to have_content "Reto: #{challenge.title}"
  end

  scenario 'and the judge already exists and HAS previous evaluations and ALSO already is evaluating the challenge' do
    email = 'judge_already_exist@email.com'
    judge = create :judge, email: email
    create :evaluation, challenge: challenge, judge: judge

    add_judge_to_challenge_with(email: email)

    expect(page).to have_content "Retos en los que actualmente participa el juez"
    expect(page).to have_content "#{challenge.title}"
    click_button 'Acepto'

    expect(page).to have_content 'El juez ya ha sido invitado previamente a evaluar el reto.'
  end

  scenario 'and the judge is not created in the system yet' do
    email = 'judge_does_not_exist_yet@email.com'

    add_judge_to_challenge_with(email: email)
    create_judge_with(name: 'this judge should now exist', email: email)
    sign_out_organization(organization)

    change_password_and_log_in email

    expect(page).to have_content 'Evaluaciones'
    expect(page).to have_content I18n.t('devise.passwords.updated')
    expect(page).to have_content "#{challenge.title}"
  end

  scenario 'and the judge is not created in the system yet and the email it provides is already in use' do
    # For this scenario I'm going to reuse the organization email
    email = organization.email
    add_judge_to_challenge_with(email: email)
    create_judge_with(name: 'this judge should now exist', email: email)

    expect(page).to have_content 'Correo ya ha sido tomado'
  end

  def change_password_and_log_in(email)
    u = User.find_by_email(email)
    visit edit_user_password_path(initial: true, reset_password_token: u.reset_password_token)
    fill_in 'user[password]', with: email
    fill_in 'user[password_confirmation]', with: email
    click_on 'Cambiar mi password'
  end

  def sign_out_organization(organization)
    click_link 'Cerrar sesión'
  end

  def sign_in_judge(email)
    visit new_user_session_path
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: email
    click_button 'Entrar'
  end

  def add_judge_to_challenge_with(args)
    click_link 'Jurado'
    click_link 'Agregar juez'
    fill_in 'email', with: args.fetch(:email)
    click_button 'Invitar'
  end

  def create_judge_with(args)
    fill_in 'user_name', with: args.fetch(:name)
    fill_in 'user_email', with: args.fetch(:email)
    click_button 'Agregar juez'
  end
end
