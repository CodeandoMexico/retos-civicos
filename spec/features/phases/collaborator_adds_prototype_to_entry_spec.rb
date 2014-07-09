require 'spec_helper'

feature 'Collaborator adds prototype to entry' do
  attr_reader :challenge

  before do
    member = create :member
    @challenge = create :challenge,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 1.week.ago,
      prototypes_phase_due_on: 1.week.from_now
    entry = create :entry,
      accepted: true,
      challenge: challenge,
      member: member

    sign_in_user(member)
    visit challenge_path(challenge)
    click_link 'Enviar prototipo'
  end

  scenario 'in the prototypes phase with good params' do
    submit_prototype_with(
      repo_url: 'github.com/ervity/miprototipo',
      demo_url: 'miprototipo.com'
    )
    current_path.should eq challenge_path(challenge)
    page.should have_content success_message(1.week.from_now)
  end

  scenario 'in the prototypes phase with bad params' do
    submit_prototype_with(
      repo_url: '',
      demo_url: ''
    )
    current_path.should eq challenge_prototypes_path(challenge)
  end

  def success_message(date)
    "Has enviado tu prototipo con éxito. Podrás editarlo hasta #{I18n.l(date.to_date, format: :long)}"
  end

  def submit_prototype_with(args)
    fill_in 'entry_repo_url', with: args.fetch(:repo_url)
    fill_in 'entry_demo_url', with: args.fetch(:demo_url)
    click_button 'Enviar prototipo'
  end
end
