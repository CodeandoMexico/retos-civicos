require 'spec_helper'

feature 'Organization admin makes an entry public' do
  attr_reader :member, :organization, :organization_admin, :challenge, :entry

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization, subdomain: 'superorg'
    @organization_admin = create :user, userable: organization
    @challenge = create :challenge, title: 'Reto 1', organization: organization
    @entry = create :entry, name: 'Mi propuesta', challenge: challenge, member: member
  end

  scenario 'in the entries list' do
    visit challenge_entry_path(challenge, entry)
    page.status_code.should eq 404

    sign_in_organization_admin(organization_admin)
    click_link 'Propuestas'

    click_button 'Hacer pública'
    click_link 'Ver vista pública'

    page.should have_content entry.name
    current_path.should eq challenge_entry_path(challenge, entry)
  end

  scenario 'in the entry page' do
    sign_in_organization_admin(organization_admin)
    click_link 'Propuestas'
    click_link 'Mi propuesta'

    click_button 'Hacer pública'
    click_link 'Ver vista pública'

    page.should have_content entry.name
    current_path.should eq challenge_entry_path(challenge, entry)
  end
end
