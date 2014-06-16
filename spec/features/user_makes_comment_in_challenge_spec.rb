require 'spec_helper'

feature 'User makes comment in challenge' do
  attr_reader :user, :organization, :challenge

  before do
    @user = create :user
    @organization = create :organization
    @challenge = create :challenge, organization: organization
    reset_email
  end

  scenario 'before login', js: true do
    visit challenge_path(challenge)
    click_link 'Comentar'

    current_path.should eq '/registrate'
    sign_in_user(user)

    visit challenge_path(challenge)
    click_on 'Comentar'
    fill_in 'comment_body', with: 'My comment'
    click_button 'Comentar'

    page_should_have_comment 'My comment'
    organization_should_receive_comment_notification(organization)
  end

  def page_should_have_comment(comment)
    within '#challenge_comments_container' do
      page.should have_content comment
    end
  end

  def organization_should_receive_comment_notification(organization)
    deliveries = ActionMailer::Base.deliveries
    deliveries.size.should be 1
    last = deliveries.last
    last.to.should include organization.email
  end
end
