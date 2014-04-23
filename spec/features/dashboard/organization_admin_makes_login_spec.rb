require 'spec_helper'

feature 'Organization admin makes login' do
  attr_reader :organization, :organization_admin

  before do
    @organization = create :organization, subdomain: 'superorg'
    @organization_admin = create :user, userable: organization
  end

  scenario 'an is redirected to a dashboard' do
    sign_in_organization_admin(organization_admin)
    current_path.should eq '/dashboard'
    should_have_subdomain 'superorg'
  end

  scenario 'and then logs out' do
    sign_in_organization_admin(organization_admin)
    click_on 'Cerrar sesión'
    visit dashboard_url subdomain: 'superorg'
    current_path.should eq '/retos'
  end

  scenario "and tries to visit other organization's dashboard" do
    create :organization, subdomain: 'otherorg'

    sign_in_organization_admin(organization_admin)
    visit dashboard_url subdomain: 'otherorg'
    current_url.should eq dashboard_url subdomain: 'superorg'
  end

  def should_have_subdomain(subdomain)
    current_host.should include subdomain
  end
end
