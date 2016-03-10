require 'spec_helper'

feature 'Organization admin makes login' do
  attr_reader :organization

  before do
    @organization = create :organization
    @challenge = create :challenge
  end

  scenario 'an is redirected to a dashboard' do
    sign_in_organization_admin(organization.admin)
    current_path.should eq '/dashboard'
    current_path.should eq dashboard_path subdomain: nil
  end

  scenario 'and then logs out' do
    sign_in_organization_admin(organization.admin)
    click_on 'Cerrar sesión'
    visit dashboard_url subdomain: 'superorg'
    current_path.should eq '/retos'
  end
end
