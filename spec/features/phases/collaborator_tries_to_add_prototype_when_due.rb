require 'spec_helper'

feature 'Collaborator fails to add/edit prototype' do
  scenario 'when the phase it\'s due' do
    member = create :member
    challenge = create :challenge,
                       ideas_phase_due_on: 3.weeks.ago,
                       ideas_selection_phase_due_on: 2.week.ago,
                       prototypes_phase_due_on: 1.week.ago
    entry = create :entry,
                   accepted: true,
                   challenge: challenge,
                   member: member

    sign_in_user(member)

    visit new_challenge_prototype_path(challenge)
    current_path.should eq challenge_path(challenge)
    page.should_not have_link 'Enviar prototipo'
    page.should_not have_link 'Editar prototipo'
  end
end
