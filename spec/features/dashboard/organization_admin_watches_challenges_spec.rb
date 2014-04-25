require 'spec_helper'

feature 'Organization admin watches challenges' do
  attr_reader :member, :organization, :organization_admin

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization, subdomain: 'superorg'
    @organization_admin = create :user, userable: organization
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

    sign_in_organization_admin(organization_admin)
    click_link 'Retos'

    page_should_have_challenge_with(
      position: 1,
      title: 'Reto en desarrollo',
      released_at: 'abril 10, 2013 20:53',
      status: 'En desarrollo',
      collaborators: 1,
      entries: 0
    )

    page_should_have_challenge_with(
      position: 2,
      title: 'Reto abierto',
      released_at: 'abril 10, 2013 20:53',
      status: 'Abierto',
      collaborators: 0,
      entries: 0
    )

    page_should_have_challenge_with(
      position: 3,
      title: 'Reto concluido',
      released_at: 'abril 10, 2013 20:53',
      status: 'Concluido',
      collaborators: 1,
      entries: 1
    )
  end

  def page_should_have_challenge_with(args)
    within "#challenges tbody tr:nth-of-type(#{args.fetch(:position)})" do
      page.should have_content args.fetch(:title)
      page.should have_content args.fetch(:released_at)
      page.should have_content args.fetch(:status)
      page.should have_content args.fetch(:collaborators)
      page.should have_content args.fetch(:entries)
    end
  end
end
