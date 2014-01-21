require 'spec_helper'

feature "Commenting on challenge" do

  let!(:member) { FactoryGirl.create(:user).userable }
  let!(:organization) { FactoryGirl.create(:user, userable: Organization.new).userable }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }

  background do
    sign_in_user(member.user, password: 'password')
    FactoryGirl.create(:collaboration, user: member.user, member: member, challenge: challenge)
  end

  scenario "Can comment", js: true do
    # Clear emails from suscriptions
    reset_email
    visit organization_challenge_path(challenge.organization.id, challenge.id)
    click_link 'Comentar'
    within '#new_comment' do
      fill_in 'comment[body]', with: 'This is my comment, hue hue hue!'
      click_button 'Comentar'
    end
    within '#challenge_comments_container' do
      page.should have_content 'This is my comment, hue hue hue!'
    end
    ActionMailer::Base.deliveries.size.should be 1
  end

  scenario "Can reply to another comment", js: true do
    FactoryGirl.create(:comment, commentable: challenge)
    # Clear emails from suscriptions
    ActionMailer::Base.deliveries.clear
    visit organization_challenge_path(challenge.organization.id, challenge.id)
    click_link 'Reply'
    within '#challenge_comments_container' do
      fill_in 'comment[body]', with: 'This is my comment!'
      click_link 'Reply'
    end
    page.should have_content 'Gracias por tus comentarios'
    ActionMailer::Base.deliveries.size.should == 1
  end
end
