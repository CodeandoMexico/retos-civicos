require 'spec_helper'

feature 'Collaborator adds prototype to entry' do
  scenario 'in the prototypes phase' do
    pending

    member = create :member
    challenge = create :challenge,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 1.week.ago,
      prototypes_phase_due_on: 1.week.from_now

    sign_in_user(member)
    visit challenge_path(challenge)
    click_on 'Enviar prototipo'

    submit_prototype_with(
      repo_url: 'github.com/ervity/miprototipo',
      demo_url: 'miprototipo.com'
    )

    current_path.should eq challenge_path(challenge)
    page.should have_content success_message(1.month.from_now)
  end

  def success_message(date)
    "Has enviado tu prototipo con éxito. Podrás editarlo hasta #{I18n.l(date.to_date, format: :long)}"
  end
end
