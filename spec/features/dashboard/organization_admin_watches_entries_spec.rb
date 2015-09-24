require 'spec_helper'

feature 'Organization admin watches entries' do
  attr_reader :member, :organization, :challenge_one, :challenge_two

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user,
      company_name: "Empresa 1",
    @organization = create :organization
  end

  scenario 'when there is no challenge' do
    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
    page.should have_content 'Propuestas'
    page.should have_content 'Aún no hay retos publicados'
  end

  scenario 'in a list' do
    create_challenges
    create :collaboration, member: member, challenge: challenge_two
    create :entry,
      name: 'Propuesta 1',
      member: member,
      challenge: challenge_two,
      idea_url: 'http://google.com',
      created_at: Time.zone.local(2013, 4, 10, 20, 53),
      technologies: ['PHP', 'MySQL']
    create :entry,
      name: 'Propuesta 2',
      member: member,
      challenge: challenge_two,
      idea_url: 'http://google.com',
      created_at: Time.zone.local(2013, 4, 12, 20, 53),
      technologies: ['Rust', 'Haskell']

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'

    page.should have_content 'Reto: Reto 2'
    page_should_have_challenges_filter_with 'Reto 2', 'Reto 1', 'Reto no activo'
    page_should_have_entry_with(
      position: 1,
      name: 'Propuesta 2',
      company_name: "Empresa 1",
      sent_at: '12 abr 20:53',
      idea_url: 'http://google.com',
      tecnologies: 'Rust, Haskell'
    )
    page_should_have_entry_with(
      position: 2,
      name: 'Propuesta 1',
      company_name: "Empresa 1",
      member: 'Juanito',
      sent_at: '10 abr 20:53',
      idea_url: 'http://google.com',
      tecnologies: 'PHP, MySQL'
    )
  end

  scenario 'with a selected filter' do
    create_challenges
    create :collaboration, member: member, challenge: challenge_one
    create :entry,
      member: member,
      name: 'Propuesta 1',
      challenge: challenge_one,
      idea_url: 'http://google.com',
      created_at: Time.zone.local(2013, 4, 10, 20, 53),
      technologies: ['PHP', 'MySQL']

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
    click_link 'Reto 1'

    page_should_have_entry_with(
      position: 1,
      name: 'Propuesta 1',
      company_name: 'Empresa 1',
      sent_at: '10 abr 20:53',
      idea_url: 'http://google.com',
      tecnologies: 'PHP, MySQL'
    )
  end

  def create_challenges
    create :challenge, :inactive, title: 'Reto no activo', organization: organization
    @challenge_one = create :challenge, title: 'Reto 1', organization: organization
    @challenge_two = create :challenge, title: 'Reto 2', organization: organization
  end

  def page_should_have_challenges_filter_with(*challenges)
    within "#challenges_options" do
      challenges.each { |challenge| page.should have_content challenge }
    end
  end

  def page_should_have_entry_with(args)
    page.should have_content args.fetch(:name)
    page.should have_content args.fetch(:sent_at)
  end
end
