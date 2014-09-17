require 'spec_helper'

feature 'Organization admin makes an entry public' do
  attr_reader :member, :organization, :challenge, :entry

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization
    @challenge = create :challenge, title: 'Reto 1', organization: organization
    @entry = create :entry, name: 'Mi propuesta', challenge: challenge, member: member, description: 'lo resuelvo'
  end

  scenario 'in the entries list' do
    visit challenge_entry_path(challenge, entry)
    page.status_code.should eq 404

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'

    click_button 'Hacer pública'
    current_full_path.should eq dashboard_entries_path(challenge_id: challenge.id)

    click_link 'Ver vista pública'
    page.should have_content entry.description
    current_path.should eq challenge_entry_path(challenge, entry)
  end

  scenario 'in the entry page' do
    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
    click_link 'Mi propuesta'

    click_button 'Hacer pública'
    click_link 'Ver vista pública'

    page.should have_content entry.name
    current_path.should eq challenge_entry_path(challenge, entry)
  end

  def current_full_path
    uri = URI.parse(current_url)
    "#{uri.path}?#{uri.query}"
  end
end
