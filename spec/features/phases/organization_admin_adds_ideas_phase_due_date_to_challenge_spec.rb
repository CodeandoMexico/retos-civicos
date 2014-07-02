require 'spec_helper'

feature 'Organization admin adds ideas phase due date to challenge' do
  scenario 'from the dashboard' do
    organization = create :organization
    challenge = create :challenge, organization: organization

    sign_in_organization_admin(organization.admin)
    visit edit_organization_challenge_path(organization, challenge)

    fill_in 'challenge_ideas_phase_due_on', with: '2014-10-08'
    click_button 'Publicar'

    visit edit_organization_challenge_path(organization, challenge)
    page.should have_field 'challenge_ideas_phase_due_on', with: '2014-10-08'
  end
end
