require 'spec_helper'

feature "Commenting on challenge" do
  let!(:member) { new_member }
  let!(:organization) { new_organization }
  let!(:challenge) { FactoryGirl.create(:challenge, organization: organization) }

  background do
    sign_in_user(member.user, password: 'password')
  end

  scenario "show 'Metodologia de evaluacion' button when phase is prototype" do
    challenge_prototype = create :challenge,
      organization: organization,
      title: 'Limpiemos México',
      pitch: 'Hagamos conciencia para un México limpio',
      entry_template_url: 'http://google.com',
      assessment_methodology: 'http://google.com',
      description: 'México esta muy sucio',
      starts_on: 5.days.ago.to_date,
      ideas_phase_due_on: 4.days.ago.to_date,
      ideas_selection_phase_due_on: 3.days.ago.to_date,
      prototypes_phase_due_on: 3.month.from_now.to_date,
      finish_on: 4.month.from_now.to_date
    entry = create :entry,
      accepted: true,
      challenge: challenge_prototype,
      member: member
    visit challenge_path(challenge_prototype)

    find_link('Metodología de Evaluación')
  end

  scenario "Can reply to a comment", js: true do
    create :comment, commentable: challenge
    # Clear emails from suscriptions
    reset_email

    visit organization_challenge_path(challenge.organization, challenge)
    within '#challenge_comments_container' do
      click_link 'Comentar'
      fill_in 'comment[body]', with: 'This is my comment!'
      click_button 'Comentar'
    end
    page.should have_content 'Gracias por tus comentarios'
    ActionMailer::Base.deliveries.size.should be 1
  end
end
