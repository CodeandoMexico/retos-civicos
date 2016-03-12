require 'spec_helper'

feature 'Organization tries to select a winner for the challenge' do
  attr_reader :entry

  before do
    member = create :member
    new_member = create :member

    organization = create :organization
    challenge = create :challenge,
                       organization: organization,
                       starts_on: 5.weeks.ago,
                       ideas_phase_due_on: 4.weeks.ago,
                       ideas_selection_phase_due_on: 3.week.ago,
                       prototypes_phase_due_on: 2.week.ago,
                       finish_on: 3.week.from_now
    winner_entry = create :entry,
                          accepted: true,
                          challenge: challenge,
                          member: member,
                          winner: 1

    @entry = create :entry,
                    accepted: true,
                    challenge: challenge,
                    member: new_member

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
  end

  scenario 'but fails because there is already a winner' do
    click_link entry.name
    page.should_not have_button 'Seleccionar como ganador'
  end
end
