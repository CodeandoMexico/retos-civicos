require 'spec_helper'

feature 'Organization admin makes login' do
  attr_reader :organization, :organization_admin

  before do
    @organization = create_organization_with subdomain: 'superorg'
    @organization_admin = organization.user
  end

  scenario 'an is redirected to a dashboard' do
    sign_in_organization_admin(organization_admin)
    current_path.should eq '/dashboard'
    should_have_subdomain 'superorg'
  end

  scenario 'and then logs out' do
    sign_in_organization_admin(organization_admin)
    click_on 'Salir'
    visit dashboard_url subdomain: 'superorg'
    current_path.should eq '/retos'
  end

  def create_organization_with(attributes)
    organization = FactoryGirl.build(:organization, attributes)
    user = FactoryGirl.create(:user, userable: organization)
    user.userable
  end

  def should_have_subdomain(subdomain)
    current_host.should include subdomain
  end
end
