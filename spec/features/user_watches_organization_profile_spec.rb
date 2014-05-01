require 'spec_helper'

feature 'User watches organization profile' do
  scenario 'with the right url' do
    create :organization

    visit '/superorg'
    page.should have_content 'Super Org'
    current_path.should eq '/superorg'
    should_not_have_subdomain 'superorg'
  end

  def should_not_have_subdomain(subdomain)
    current_host.should_not include subdomain
  end
end
