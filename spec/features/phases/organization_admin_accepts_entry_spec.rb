require 'spec_helper'

feature 'Organization admin accepts entry' do
  scenario 'in the ideas selection phase' do
    organization = create :organization
    challenge = create :challenge,
      organization: organization,
      ideas_phase_due_on: 2.weeks.ago,
      ideas_selection_phase_due_on: 2.weeks.from_now
    entry = create :entry, challenge: challenge
    sign_in_organization_admin(organization.admin)

    reset_email
    visit dashboard_entry_path(entry)
    click_on 'Seleccionar como finalista'
    page.should have_content 'La propuesta fue aceptada satisfactoriamente'
    entry_author_should_receive_an_accepted_entry_email(entry)
    expect(page).to have_content entry.name
  end

  scenario 'in the ideas phase but fails' do
    organization = create :organization
    challenge = create :challenge,
      organization: organization,
      ideas_phase_due_on: 2.weeks.from_now
    entry = create :entry, challenge: challenge

    sign_in_organization_admin(organization.admin)
    visit dashboard_entry_path(entry)
    page.should_not have_button 'Aceptar propuesta'
  end

  def entry_author_should_receive_an_accepted_entry_email(entry)
    email = ActionMailer::Base.deliveries.last || :no_email
    email.to.should include entry.member.email
    email.subject.should include 'Pasaste a la siguiente etapa'
  end
end
