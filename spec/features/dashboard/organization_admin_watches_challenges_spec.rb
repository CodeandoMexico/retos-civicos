require 'spec_helper'

feature 'Organization admin watches challenges' do
  attr_reader :member, :organization

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization
  end

  scenario 'in a table' do
    finished = create :challenge, :finished,
                      title: 'Reto concluido',
                      organization: organization,
                      starts_on: Date.new(2013, 4, 10),
                      ideas_phase_due_on: Date.new(2013, 5, 10),
                      ideas_selection_phase_due_on: Date.new(2013, 6, 10),
                      prototypes_phase_due_on: Date.new(2013, 7, 10),
                      finish_on: Date.new(2013, 8, 10),
                      created_at: Time.zone.local(2013, 4, 10, 20, 53)

    open = create :challenge, :open,
                  title: 'Reto Prototipos',
                  organization: organization,
                  starts_on: Date.new(2013, 4, 10),
                  ideas_phase_due_on: Date.new(2013, 5, 10),
                  ideas_selection_phase_due_on: Date.new(2013, 6, 10),
                  prototypes_phase_due_on: Date.new(2113, 7, 10),
                  finish_on: Date.new(2113, 8, 10),
                  created_at: Time.zone.local(2013, 4, 10, 20, 53)

    create :challenge, :working_on,
           title: 'Reto en ideas',
           organization: organization,
           starts_on: Date.new(2013, 4, 10),
           ideas_phase_due_on: Date.new(2113, 5, 10),
           ideas_selection_phase_due_on: Date.new(2113, 6, 10),
           prototypes_phase_due_on: Date.new(2113, 7, 10),
           finish_on: Date.new(2113, 8, 10),
           created_at: Time.zone.local(2013, 4, 10, 20, 53)

    create :collaboration, member: member, challenge: open
    create :collaboration, member: member, challenge: finished
    create :entry, member: member, challenge: finished

    sign_in_organization_admin(organization.admin)
    click_link 'Retos'

    page_should_have_challenge_with(
      position: 1,
      title: 'Reto en ideas',
      phase: 'Ideas'
    )

    page_should_have_challenge_with(
      position: 2,
      title: 'Reto Prototipos',
      phase: 'Prototipos'
    )

    page_should_have_challenge_with(
      position: 3,
      title: 'Reto concluido',
      phase: 'Concluido'
    )
  end

  def page_should_have_challenge_with(args)
    page.should have_content args.fetch(:title)
    page.should have_content args.fetch(:phase)
  end
end
