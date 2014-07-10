require 'spec_helper'

feature 'Organization admin watches collaborators' do
  attr_reader :organization, :inactive_challenge, :active_challenge, :juanito, :pepito

  before do
    @organization = create :organization
    @juanito = create_member name: 'Juanito', email: 'juanito@example.com'
    @pepito = create_member name: 'Pepito', email: 'pepito@example.com'
  end

  scenario 'when there is no challenge' do
    sign_in_organization_admin(organization.admin)
    click_link 'Participantes'
    page.should have_content 'Participantes'
    page.should have_content 'Aún no hay retos publicados'
  end

  scenario 'in a table' do
    create_challenges
    create :collaboration, member: pepito, challenge: active_challenge
    create :collaboration, member: juanito, challenge: active_challenge

    sign_in_organization_admin(organization.admin)
    click_link 'Participantes'

    page.should have_content 'Reto: Reto activo'
    page_should_have_challenges_filter_with 'Reto activo', 'Reto no activo'
    page_should_have_collaborator_with(
      position: 1,
      id: juanito.id,
      name: 'Juanito',
      email: 'juanito@example.com',
      registered_at: juanito.created_at
    )

    page_should_have_collaborator_with(
      position: 2,
      id: pepito.id,
      name: 'Pepito',
      email: 'pepito@example.com',
      registered_at: pepito.created_at
    )
  end

  scenario 'with a selected filter' do
    create_challenges
    create :collaboration, member: juanito, challenge: inactive_challenge

    sign_in_organization_admin(organization.admin)
    click_link 'Participantes'
    click_link 'Reto no activo'

    page.should have_content 'Reto: Reto no activo'
    page_should_have_collaborator_with(
      position: 1,
      id: juanito.id,
      name: 'Juanito',
      email: 'juanito@example.com',
      registered_at: juanito.created_at
    )
  end

  def create_member(attrs)
    create :member, user: (create :user, attrs)
  end

  def create_challenges
    @inactive_challenge = create :challenge, :inactive, title: 'Reto no activo', organization: organization
    @active_challenge = create :challenge, title: 'Reto activo', organization: organization
  end

  def page_should_have_challenges_filter_with(*challenges)
    within "#challenges_options" do
      challenges.each { |challenge| page.should have_content challenge }
    end
  end

  def page_should_have_collaborator_with(args)
    within "#collaborators tbody tr:nth-of-type(#{args.fetch(:position)})" do
      page.should have_content args.fetch(:id)
      page.should have_content args.fetch(:name)
      page.should have_content args.fetch(:email)
      page.should have_content I18n.l(args.fetch(:registered_at), format: :long)
    end
  end
end
