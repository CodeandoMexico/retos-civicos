require 'spec_helper'

feature 'Collaborator fails to add/edit entry' do
  scenario 'when the phase it\'s due' do
    member = create :member
    challenge = create :challenge,
                       ideas_phase_due_on: 1.weeks.ago,
                       ideas_selection_phase_due_on: 2.weeks.from_now,
                       prototypes_phase_due_on: 3.weeks.from_now
    entry = create :entry,
                   challenge: challenge,
                   member: member

    sign_in_user(member)

    visit edit_challenge_entry_path(challenge, entry)
    current_path.should eq challenge_path(challenge)
    page.should_not have_link 'Enviar propuesta'
    page.should_not have_link 'Editar propuesta'
  end
end
