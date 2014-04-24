require 'spec_helper'

feature 'Organization admin makes an entry public' do
  attr_reader :member, :organization, :organization_admin

  before do
    user = create :user, name: 'Juanito'
    @member = create :member, user: user
    @organization = create :organization, subdomain: 'superorg'
    @organization_admin = create :user, userable: organization
  end

  scenario 'in the entries list' do
    challenge = create :challenge, title: 'Reto 1', organization: organization
    entry = create :entry, challenge: challenge, member: member

    visit challenge_entry_path(challenge, entry)
    page.status_code.should eq 404
    sign_in_organization_admin(organization_admin)
    click_link 'Propuestas'
    click_button 'Hacer pública'
    click_link 'Ver vista pública'

    page.should have_content entry.name
    current_path.should eq challenge_entry_path(challenge, entry)
  end
end
