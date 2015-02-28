require 'spec_helper'

feature 'Admin logs into jury section' do
  attr_reader :challenge_name, :judge

  before do
    @challenge_name = 'Primer reto'

    organization = create :organization
    organization_admin = create :user, userable: organization
    challenge = create :challenge, title: @challenge_name, organization: organization

    @judge = create :judge, email: 'judge@site.com'

    sign_in_organization_admin(organization_admin)
  end


  scenario 'user clicks on a challenge and invites a judge(not in the db yet) with valid information' do
    navigate_to_jury_path

    invite_new_judge_to_challenge('A Valid Judge', 'correo@valido.com')
    expect(page).to have_content I18n.t('flash.judge.saved_successfully')
  end

  scenario 'user clicks on a challenge and invites a judge with invalid information' do
    navigate_to_jury_path

    invite_new_judge_to_challenge('Juez 1', 'correo_incorrecto@.com')
    expect(page).to have_content 'El usuario no pudo guardarse'
  end

  scenario 'user clicks on a challenge and invites a judge(already in the db) with valid information' do
    navigate_to_jury_path

    invite_existing_judge_to_challenge(judge)
    expect(page).to have_content I18n.t('flash.judge.added_succesfully_for_this_challenge')
  end

  scenario 'user clicks on a challenge and invites a judge(already in the db) twice to an evaluation' do
    # we are going to try and invite the judge twice
    2.times do |n|
      navigate_to_jury_path
      invite_existing_judge_to_challenge(judge)
    end

    expect(page).to have_content I18n.t('flash.judge.evaluation_already_exists_for_this_challenge')
  end

  def invite_existing_judge_to_challenge(judge)
    click_on I18n.t('dashboard.judges.index.new_judge')

    submit_email_for_challenge(judge.email)
    expect(page).to have_content judge.name
    click_on I18n.t('dashboard.judges.request_permission_for_challenge.submit')
  end

  def invite_new_judge_to_challenge(new_user_name, new_user_email)
    click_on I18n.t('dashboard.judges.index.new_judge')

    submit_email_for_challenge(new_user_email)
    create_new_judge(new_user_name, new_user_email)
  end

  def navigate_to_jury_path
    click_link 'Jurado'
  end

  # new judge helpers
  def submit_email_for_challenge(email)
    fill_in 'email', with: email
    click_on 'Crear'
  end

  def create_new_judge(new_user_name, new_user_email)
    fill_in 'user_email', with: new_user_email
    fill_in 'user_name', with: new_user_name
    click_on 'Agregar juez'
  end
end
