require 'spec_helper'

feature 'User watches the current phase of a challenge' do
  scenario 'when the current phase is the ideas phase' do
    challenge = create :challenge,
      starts_on: 3.days.ago,
      ideas_phase_due_on: 7.days.from_now.to_date

    visit challenge_path(challenge)
    page_should_show_completness_of_ideas_phase('30.0')
  end

  def page_should_show_completness_of_ideas_phase(percentage)
    within ".phases-bar-phase:nth-child(2)" do
      page.should have_css "[data-width='#{percentage}']"
      page.should have_content 'Ideas'
    end
  end
end
