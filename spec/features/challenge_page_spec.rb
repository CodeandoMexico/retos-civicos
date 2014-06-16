require 'spec_helper'

feature "Commenting on challenge" do
  let!(:member) { new_member }
  let!(:organization) { new_organization }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }

  background do
    sign_in_user(member.user, password: 'password')
  end

  scenario "Can reply to a comment", js: true do
    create :comment, commentable: challenge
    # Clear emails from suscriptions
    reset_email

    visit organization_challenge_path(challenge.organization, challenge)
    within '#challenge_comments_container' do
      click_link 'Comentar'
      fill_in 'comment[body]', with: 'This is my comment!'
      click_button 'Comentar'
    end
    page.should have_content 'Gracias por tus comentarios'
    ActionMailer::Base.deliveries.size.should be 1
  end
end
