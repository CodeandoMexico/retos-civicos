require 'spec_helper'

feature 'Collaborator fails to add prototype' do
  attr_reader :member, :challenge

  before do
    @member = create :member
    @challenge = create :challenge,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 1.week.ago,
      prototypes_phase_due_on: 1.week.from_now

    sign_in_user(member)
    visit challenge_path(challenge)
  end

  scenario 'in the prototypes phase with no entry' do
    page.should_not have_link 'Enviar prototipo'
  end

  scenario 'in the prototypes phase with an unaccepted entry' do
    member_entry(false)
    page.should_not have_link 'Enviar prototipo'
  end

  def member_entry(accepted)
    entry = create :entry,
      accepted: accepted,
      challenge: challenge,
      member: member
  end
end
