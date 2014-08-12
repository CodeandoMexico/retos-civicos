require 'spec_helper'
feature 'Organization admin creates a private challenge' do
  attr_reader :organization_admin, :challenge

  scenario 'admin visits page' do
    organization = create :organization
    organization_admin = create :user, userable: organization
    challenge = create :challenge, title: 'Reto activo', organization: organization, status: 'private'

    sign_in_organization_admin(organization_admin)
    visit challenge_path(challenge)
    page.status_code.should eq 200
  end

  scenario 'user visits page' do
    organization = create :organization
    organization_admin = create :user, userable: organization
    challenge = create :challenge, title: 'Reto activo', organization: organization, status: 'private'

    visit challenge_path(challenge)
    page.status_code.should eq 404
  end
end
