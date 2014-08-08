require 'spec_helper'

feature 'Organization selects winner for the challenge' do
  attr_reader :challenge, :entry

  before do
    member = create :member
    organization = create :organization
    @challenge = create :challenge,
      organization: organization,
      starts_on: 5.weeks.ago,
      ideas_phase_due_on: 4.weeks.ago,
      ideas_selection_phase_due_on: 3.week.ago,
      prototypes_phase_due_on: 2.week.ago
    @entry = create :entry,
      accepted: true,
      challenge: challenge,
      member: member

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
  end

  scenario 'in the prototypes selection phase' do
    select_winner
    page.should have_content "La propuesta \"#{entry.name}\" fue seleccionada ganadora"
    visit challenge_entry_path(challenge, entry)
    page.should have_content "Ganador"
    page.should have_content entry.name
  end

  scenario 'in the prototypes selection phase, and then removes him' do
    select_winner
    remove_winner
    page.should have_content "A esta propuesta le fue quitada el estatus de ganadora correctamente."
  end

  scenario 'and the challenge page should show the finalists and the winner' do
    select_winner
    add_finalist_entries(4)

    visit challenge_path(challenge)
    page.should have_content "Ganador"
    page.should have_content entry.name
    page.should have_content "Finalistas"
  end

  def select_winner
    click_link entry.name
    click_button "Seleccionar como ganador"
  end

  def remove_winner
    click_link entry.name
    click_button "Quitar como ganadora"
  end

  def add_finalist_entries(number_of_entries)
    (1..number_of_entries).each do
      create_new_entry
    end
  end

  def create_new_entry
    create :entry, accepted: true, challenge: challenge, member: (create :member)
  end

end
