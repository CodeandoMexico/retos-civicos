require 'spec_helper'

feature 'User watches the current phase of a challenge when the current phase is the selections ideas phase' do
  scenario 'anyone should see the total number of entries' do
    challenge = create :challenge,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 1.week.from_now,
      prototypes_phase_due_on: 2.week.from_now

    visit challenge_path(challenge)
    page.should have_content 'Estamos evaluando y seleccionando las 0 ideas recibidas'
  end

  scenario 'anyone should see the total number of entries' do
    member = create :member
    challenge = create :challenge,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 1.week.from_now,
      prototypes_phase_due_on: 2.week.from_now
    entry = create :entry,
      accepted: true,
      challenge: challenge,
      member: member

    sign_in_user member
    visit challenge_path(challenge)

    page.should have_content '1 propuesta recibida'
  end
end
