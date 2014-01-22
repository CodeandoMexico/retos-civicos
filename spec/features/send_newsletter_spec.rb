require 'spec_helper'

feature "Send newsletter to collaborators" do

  let!(:organization) { new_organization }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }
  let!(:members) { FactoryGirl.create_list(:user, 5).map(&:userable) }

  background do
    sign_in_user(organization.user, password: 'password')
    members.each do |member|
      member.collaborations.create(challenge: challenge)
    end
  end

  scenario "Can send newsletter to all collaborators" do
    reset_email
    visit send_newsletter_organization_challenge_path(organization.id, challenge.id)

    fill_in "subject", with: "This is a subject wow!"
    fill_in "body", with: "Body of newsletter"
    click_button("Enviar newsletter")

    ActionMailer::Base.deliveries.size.should be challenge.collaborators.count
  end

end
