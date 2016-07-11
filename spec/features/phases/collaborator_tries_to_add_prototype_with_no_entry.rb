require 'spec_helper'

feature 'Collaborator fails to add prototype in the prototypes phase' do
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

  scenario 'with no entry via a prototype button' do
    page.should_not have_link 'Enviar prototipo'
  end

  scenario 'with an unaccepted entry via a prototype button' do
    create_member_entry(false)
    page.should_not have_link 'Enviar prototipo'
  end

  scenario 'with no entry via url' do
    visit new_challenge_prototype_path(challenge)
    current_path.should eq challenge_path(challenge)
  end

  scenario 'with an existent but unaccepted entry via url' do
    create_member_entry(false)
    visit new_challenge_prototype_path(challenge)
    current_path.should eq challenge_path(challenge)
  end

  scenario 'with an existent and accepted entry via url' do
    create_member_entry(true)
    visit new_challenge_prototype_path(challenge)
    current_path.should eq new_challenge_prototype_path(challenge)
  end

  def create_member_entry(accepted)
    entry = create :entry,
                   accepted: accepted,
                   challenge: challenge,
                   member: member
  end
end
