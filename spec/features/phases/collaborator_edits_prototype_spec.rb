require 'spec_helper'

feature 'Collaborator edits prototype' do
  attr_reader :challenge, :entry

  before do
    member = create :member
    @challenge = create :challenge,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 1.week.ago,
      prototypes_phase_due_on: 1.week.from_now
    @entry = create :entry,
      accepted: true,
      challenge: challenge,
      member: member,
      repo_url: 'github.com/ervity/miprototipo',
      demo_url: 'miprototipo.com'

    sign_in_user(member)
    visit challenge_path(challenge)
    click_link 'Editar prototipo'
  end

  scenario 'in the prototypes phase with valid params' do
    edit_prototype_with(
      repo_url: 'github.com/ervity/miprototipoeditado',
      demo_url: 'miprototipoeditado.com'
    )
    current_path.should eq challenge_path(challenge)
  end

  scenario 'in the prototypes phase with invalid params' do
    edit_prototype_with(
      repo_url: '',
      demo_url: ''
    )
    current_path.should eq challenge_prototype_path(challenge, entry)
  end

  def edited_success_message(date)
    "Has editado tu prototipo con éxito. Podrás editarlo hasta #{I18n.l(date.to_date, format: :long)}"
  end

  def edit_prototype_with(args)
    fill_in 'entry_repo_url', with: args.fetch(:repo_url)
    fill_in 'entry_demo_url', with: args.fetch(:demo_url)
    click_button 'Editar prototipo'
  end
end
