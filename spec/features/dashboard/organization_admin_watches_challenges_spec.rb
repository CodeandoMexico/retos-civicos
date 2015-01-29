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
      created_at: Time.zone.local(2013, 4, 10, 20, 53)

    open = create :challenge, :open,
      title: 'Reto abierto',
      organization: organization,
      created_at: Time.zone.local(2013, 4, 10, 20, 53)

    working_on = create :challenge, :working_on,
      title: 'Reto en desarrollo',
      organization: organization,
      created_at: Time.zone.local(2013, 4, 10, 20, 53)

    create :collaboration, member: member, challenge: open
    create :collaboration, member: member, challenge: finished
    create :entry, member: member, challenge: finished

    sign_in_organization_admin(organization.admin)
    click_link 'Retos'

    page_should_have_challenge_with(
      position: 1,
      title: 'Reto en desarrollo',
      status: 'En desarrollo',
      collaborators: 1,
      entries: 0
    )

    page_should_have_challenge_with(
      position: 2,
      title: 'Reto abierto',
      status: 'Abierto',
      collaborators: 0,
      entries: 0
    )

    page_should_have_challenge_with(
      position: 3,
      title: 'Reto concluido',
      status: 'Concluido',
      collaborators: 1,
      entries: 1
    )
  end

  def page_should_have_challenge_with(args)
    page.should have_content args.fetch(:title)
    page.should have_content args.fetch(:status)
    page.should have_content args.fetch(:collaborators)
    page.should have_content args.fetch(:entries)
  end
end
