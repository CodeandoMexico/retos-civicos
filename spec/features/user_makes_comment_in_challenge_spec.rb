# encoding: utf-8
require 'spec_helper'

feature 'User makes comment in challenge' do
  attr_reader :organization, :challenge

  before do
    other_challenge = create :challenge
    @organization = create :organization
    @challenge = create :challenge, organization: organization
    reset_email
  end

  scenario 'before signup', js: true do
    visit challenge_path(challenge)
    click_link 'Crear comentario'

    current_path.should eq '/registrate'
    sign_up_user

    current_path.should eq edit_member_path(member_that_just_signed_up)
    click_button 'Actualizar'

    current_path.should eq challenge_path(challenge)
    click_on 'Crear comentario', match: :first
    fill_in 'comment_body', with: 'My comment'
    click_button 'Crear comentario'

    page_should_have_comment 'My comment'
    organization_should_receive_comment_notification(organization)
  end

  scenario 'before login', js: true do
    user = create :user, updated_at: 1.week.ago
    visit challenge_path(challenge)
    click_link 'Crear comentario'

    current_path.should eq '/registrate'
    sign_in_user(user)

    current_path.should eq challenge_path(challenge)
    click_on 'Crear comentario', match: :first
    fill_in 'comment_body', with: 'My comment'
    click_button 'Crear comentario'

    page_should_have_comment 'My comment'
    organization_should_receive_comment_notification(organization)

    click_on 'Responder', match: :first
    fill_in 'comment_body', with: 'my response'
    click_on 'Responder'

    click_link user.name, match: :first
    click_link 'Cerrar sesión'
    click_on 'Inicia sesión'
    click_on 'Inicia con Email'
    fill_in 'user_email', with: organization.admin.email
    fill_in 'user_password', with: 'password'
    click_on 'Entrar'
    visit challenge_path(challenge)
    find(:xpath, "//a[contains(@href,'like=true')]").click
  end

  def sign_up_user
    click_on 'Inicia con Email'
    click_on 'Regístrate aquí'
    fill_in 'user_email', with: 'jose@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Registrarme'
  end

  def member_that_just_signed_up
    User.last.userable
  end

  def page_should_have_comment(comment)
    within '#challenge_comments_container' do
      page.should have_content comment
    end
  end

  def organization_should_receive_comment_notification(organization)
    deliveries = ActionMailer::Base.deliveries
    last = deliveries.last
    last.to.should include organization.email
  end
end
