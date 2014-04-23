require 'spec_helper'

feature 'Organization admin visits dashboard' do
  attr_reader :member, :organization, :organization_admin

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization, subdomain: 'superorg'
    @organization_admin = create :user, userable: organization
    create :challenge, :inactive, organization: organization
  end

  scenario 'and watches the last challenges and last entries' do
    challenge = create :challenge, title: 'Reto 1', organization: organization
    create :collaboration, member: member, challenge: challenge
    create :entry,
      name: 'Propuesta 1',
      member: member,
      challenge: challenge,
      github_url: 'http://miproyecto.com',
      created_at: Time.zone.local(2013, 4, 10, 20, 53)

    sign_in_organization_admin(organization_admin)
    page_should_have_challenge_with(
      title: 'Reto 1',
      collaborators: 1,
      entries: 1,
    )
    page_should_have_entry_with(
      name: 'Propuesta 1',
      member: 'Juanito',
      sent_at: '10 abr 20:53',
      link: 'http://miproyecto.com',
      challenge: 'Reto 1'
    )
  end

  def page_should_have_challenge_with(args)
    within "#challenges" do
      page.should have_content args.fetch(:title)
      page.should have_content args.fetch(:collaborators)
      page.should have_content args.fetch(:entries)
    end
  end

  def page_should_have_entry_with(args)
    within "#entries" do
      page.should have_content args.fetch(:name)
      page.should have_content args.fetch(:member)
      page.should have_content args.fetch(:sent_at)
      page.should have_content args.fetch(:link)
      page.should have_content args.fetch(:challenge)
    end
  end
end
