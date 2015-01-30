require 'spec_helper'

feature 'Organization admin visits dashboard' do
  attr_reader :member, :organization

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization
    create :challenge, :inactive, organization: organization
  end

  scenario 'and watches the last challenges and last entries' do
    challenge = create :challenge, title: 'Reto 1', organization: organization
    create :collaboration, member: member, challenge: challenge
    create :entry,
      name: 'Propuesta 1',
      member: member,
      challenge: challenge,
      idea_url: 'http://miproyecto.com',
      created_at: Time.zone.local(2013, 4, 10, 20, 53)

    sign_in_organization_admin(organization.admin)
    page_should_have_challenge_with(
      title: 'Reto 1',
      collaborators: 1,
      entries: 1,
    )
    page_should_have_entry_with(
      name: 'Propuesta 1',
      member: 'Juanito',
      sent_at: '10 abr 20:53',
      idea_url: 'http://miproyecto.com',
      challenge: 'Reto 1'
    )
  end

  def page_should_have_challenge_with(args)
    page.should have_content args.fetch(:title)
    page.should have_content args.fetch(:collaborators)
    page.should have_content args.fetch(:entries)
  end

  def page_should_have_entry_with(args)
    page.should have_content args.fetch(:name)
    page.should have_content args.fetch(:sent_at)
  end
end
