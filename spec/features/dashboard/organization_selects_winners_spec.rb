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
                        prototypes_phase_due_on: 2.week.ago,
                        finish_on: 1.day.ago
    @entry = create :entry,
                    accepted: true,
                    challenge: challenge,
                    member: member

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
  end

  scenario 'in the prototypes selection phase' do
    select_as_winner(entry)
    expect(page).to have_content "La propuesta \"#{entry.name}\" fue seleccionada ganadora"
    challenge.finish_on = 1.day.ago
    challenge.save
    visit challenge_path(challenge)
    expect(page).to have_content 'Entry Winner'
    expect(page).to have_content entry.name
  end

  scenario 'in the prototypes selection phase, and then removes him' do
    select_as_winner(entry)
    remove_entry_as_winner(entry)

    expect(page).to have_content 'A esta propuesta le fue quitada el estatus de ganadora correctamente.'
  end

  scenario 'and the challenge page should show the finalists and the winner' do
    select_as_winner(entry)
    add_finalist_entries(4)
    challenge_has_finished

    visit challenge_path(challenge)

    expect(page).to have_content 'Entry Winner'
    expect(page).to have_content entry.name
    expect(page).to have_content 'Finalista'
  end

  def select_as_winner(_entry)
    click_link 'entry__1'
    click_button 'Seleccionar como ganador'
  end

  def remove_entry_as_winner(_entry)
    click_link 'entry__1'
    click_button 'Quitar como ganadora'
  end

  def add_finalist_entries(number_of_entries)
    new_finalists_entries = []
    number_of_entries.times { |_n| new_finalists_entries << create(:entry, accepted: true, challenge: challenge, member: (create :member)) }
  end

  def challenge_has_finished
    challenge.finish_on = 1.week.ago
    challenge.save
  end
end
