require 'spec_helper'

feature 'Organization admin adds phases dates to challenge' do
  scenario 'from the dashboard' do
    organization = create :organization
    challenge = create :challenge, organization: organization

    sign_in_organization_admin(organization.admin)
    visit edit_dashboard_challenge_path(challenge)

    fill_in 'challenge_starts_on', with: '2014-05-08'
    fill_in 'challenge_ideas_phase_due_on', with: '2014-06-08'
    fill_in 'challenge_ideas_selection_phase_due_on', with: '2014-07-08'
    fill_in 'challenge_prototypes_phase_due_on', with: '2014-08-08'
    fill_in 'challenge_finish_on', with: '2014-09-08'
    click_button 'Publicar'

    visit edit_dashboard_challenge_path(challenge)
    page.should have_field 'challenge_starts_on', with: '2014-05-08'
    page.should have_field 'challenge_ideas_phase_due_on', with: '2014-06-08'
    page.should have_field 'challenge_ideas_selection_phase_due_on', with: '2014-07-08'
    page.should have_field 'challenge_prototypes_phase_due_on', with: '2014-08-08'
    page.should have_field 'challenge_finish_on', with: '2014-09-08'
  end
end
