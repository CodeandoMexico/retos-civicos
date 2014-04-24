require 'spec_helper'

feature 'Organization admin watches entries' do
  attr_reader :member, :organization, :organization_admin, :challenge_one, :challenge_two

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization, subdomain: 'superorg'
    @organization_admin = create :user, userable: organization
    create :challenge, :inactive, title: 'Reto no activo', organization: organization
    @challenge_one = create :challenge, title: 'Reto 1', organization: organization
    @challenge_two = create :challenge, title: 'Reto 2', organization: organization
  end

  scenario 'in a list' do
    create :collaboration, member: member, challenge: challenge_two
    create :entry,
      name: 'Propuesta 1',
      member: member,
      challenge: challenge_two,
      github_url: 'http://miproyecto.com',
      created_at: Time.zone.local(2013, 4, 10, 20, 53),
      technologies: 'PHP, MySQL'
    create :entry,
      name: 'Propuesta 2',
      member: member,
      challenge: challenge_two,
      github_url: 'http://otroproyecto.com',
      created_at: Time.zone.local(2013, 4, 12, 20, 53),
      technologies: 'Rust, Haskell'

    sign_in_organization_admin(organization_admin)
    click_link 'Propuestas'

    page.should have_content 'Reto: Reto 2'
    page_should_have_challenges_filter_with 'Reto 2', 'Reto 1', 'Reto no activo'
    page_should_have_entry_with(
      position: 1,
      name: 'Propuesta 2',
      member: 'Juanito',
      sent_at: '12 abr 20:53',
      link: 'http://otroproyecto.com',
      tecnologies: 'Rust, Haskell'
    )
    page_should_have_entry_with(
      position: 2,
      name: 'Propuesta 1',
      member: 'Juanito',
      sent_at: '10 abr 20:53',
      link: 'http://miproyecto.com',
      tecnologies: 'PHP, MySQL'
    )
  end

  scenario 'with a selected filter' do
    create :collaboration, member: member, challenge: challenge_one
    create :entry,
      name: 'Propuesta 1',
      member: member,
      challenge: challenge_one,
      github_url: 'http://miproyecto.com',
      created_at: Time.zone.local(2013, 4, 10, 20, 53),
      technologies: 'PHP, MySQL'

    sign_in_organization_admin(organization_admin)
    click_link 'Propuestas'
    click_link 'Reto 1'

    page_should_have_entry_with(
      position: 1,
      name: 'Propuesta 1',
      member: 'Juanito',
      sent_at: '10 abr 20:53',
      link: 'http://miproyecto.com',
      tecnologies: 'PHP, MySQL'
    )
  end

  def page_should_have_challenges_filter_with(*challenges)
    within "#challenges_options" do
      challenges.each { |challenge| page.should have_content challenge }
    end
  end

  def page_should_have_entry_with(args)
    within "#entries tbody tr:nth-of-type(#{args.fetch(:position)})" do
      page.should have_content args.fetch(:name)
      page.should have_content args.fetch(:member)
      page.should have_content args.fetch(:sent_at)
      page.should have_content args.fetch(:link)
      page.should have_content args.fetch(:tecnologies)
    end
  end
end
