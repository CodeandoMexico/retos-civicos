require 'spec_helper'

feature 'Organization selects winner for the challenge' do
  attr_reader :challenge, :entry, :organization

  before do
    member = create :member
    organization = create :organization
    @challenge = create :challenge,
      organization: organization,
      starts_on: 5.weeks.ago,
      ideas_phase_due_on: 4.weeks.ago,
      ideas_selection_phase_due_on: 3.week.ago,
      prototypes_phase_due_on: 2.week.ago,
      finish_on: 2.week.from_now
    @entry = create :entry,
      accepted: true,
      challenge: challenge,
      member: member

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
  end

  scenario 'in the prototypes selection phase' do
    select_winner
    page.should have_content "Esta propuesta fue seleccionada correctamente como ganadora."
  end

  scenario 'in the prototypes selection phase, and then removes him' do
    select_winner
    remove_winner
    page.should have_content "A esta propuesta le fue quitada el estatus de ganadora correctamente."
  end

  scenario 'in the prototypes phase, but fails because the button should not be available' do
    challenge = create :challenge,
      organization: organization,
      starts_on: 5.weeks.ago,
      ideas_phase_due_on: 4.weeks.ago,
      ideas_selection_phase_due_on: 3.week.ago,
      prototypes_phase_due_on: 1.week.from_now,
      finish_on: 2.week.from_now

    # should have a text that marks this as the winner, when that's done this text should be replaced to look for it
    page.should_not have_button "Seleccionar como ganadora"
  end

  def select_winner
    click_link entry.name
    click_button "Seleccionar como ganadora"
  end

  def remove_winner
    click_link entry.name
    click_button "Quitar como ganadora"
  end
end
