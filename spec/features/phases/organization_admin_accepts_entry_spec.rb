require 'spec_helper'

feature 'Organization admin accepts entry' do
  scenario 'in the ideas selection phase' do
    organization = create :organization
    challenge = create :challenge,
      organization: organization,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 2.weeks.from_now
    entry = create :entry, challenge: challenge

    sign_in_organization_admin(organization.admin)
    visit dashboard_entry_path(entry)
    click_on 'Aceptar propuesta'

    page.should have_content 'La propuesta fue aceptada satisfactoriamente'
    within_entry(entry) { page.should have_content 'Aceptada' }

    visit dashboard_entry_path(entry)
    page.should_not have_button 'Aceptar propuesta'
  end

  scenario 'in the ideas phase but fails' do
    organization = create :organization
    challenge = create :challenge,
      organization: organization,
      ideas_phase_due_on: 2.weeks.from_now
    entry = create :entry, challenge: challenge

    sign_in_organization_admin(organization.admin)
    visit dashboard_entry_path(entry)
    page.should_not have_button 'Aceptar propuesta'
  end

  def within_entry(entry)
    within("#entry_#{entry.id}") { yield }
  end
end
