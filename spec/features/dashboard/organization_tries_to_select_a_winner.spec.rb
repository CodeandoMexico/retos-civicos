require 'spec_helper'

feature 'Organization tries to select a winner for the challenge' do
  before do
    member = create :member
    organization = create :organization
    challenge = create :challenge,
                       organization: organization,
                       starts_on: 5.weeks.ago,
                       ideas_phase_due_on: 4.weeks.ago,
                       ideas_selection_phase_due_on: 3.week.ago,
                       prototypes_phase_due_on: 2.week.from_now,
                       finish_on: 3.week.from_now
    entry = create :entry,
                   accepted: true,
                   challenge: challenge,
                   member: member

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
    click_link entry.name
  end

  scenario 'but fails because it isn\'t in the prototyepes evaluation phase' do
    page.should_not have_button 'Seleccionar como ganador'
  end
end
