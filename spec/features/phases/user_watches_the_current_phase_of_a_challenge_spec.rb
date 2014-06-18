require 'spec_helper'

feature 'User watches the current phase of a challenge' do
  scenario 'when the current phase is the ideas phase' do
    challenge = create :challenge, ideas_phase_due_on: 1.month.from_now.to_date

    visit challenge_path(challenge)
    current_phase_should_be 'Ideas'
  end

  scenario 'when the current phase is the ideas selection phase' do
    challenge = create :challenge,
      ideas_phase_due_on: 1.day.ago.to_date,
      ideas_selection_phase_due_on: 1.month.from_now.to_date

    visit challenge_path(challenge)
    current_phase_should_be 'Selección de ideas'
  end

  def current_phase_should_be(phase)
    within '#current_challenge_phase' do
      page.should have_content phase
    end
  end
end
