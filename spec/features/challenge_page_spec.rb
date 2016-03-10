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
    click_link member.user.name, match: :first
    click_link 'Cerrar sesión'
    sign_in_user(organization.admin, password: 'password')
    visit dashboard_judges_path(challenge_id: challenge.id)
    click_on "Acciones", match: :first
    click_on "Exportar CSV", match: :first
    visit dashboard_judges_path(challenge_id: challenge.id)
    click_on "Acciones", match: :first
    click_on "Criterios de evaluación", match: :first
    fill_in "criteria__description", match: :first, with: "HI"
    fill_in "criteria__value", match: :first, with: "100"
    click_button "Guardar"
    click_on "Jurado"
    click_on "Acciones"
    click_on "Cerrar evaluaciones"

  end

  scenario "Can reply to a comment", js: true do
    create :comment, commentable: challenge
    # Clear emails from suscriptions
    reset_email

    visit organization_challenge_path(challenge.organization, challenge)
    click_link 'Crear comentario', match: :first
    within '#new_comment', match: :first do
      fill_in 'comment[body]', with: 'This is my comment!'
      click_button 'Crear comentario'
    end
    page.should have_content 'This is my comment!'
    ActionMailer::Base.deliveries.size.should be 1
  end
end
