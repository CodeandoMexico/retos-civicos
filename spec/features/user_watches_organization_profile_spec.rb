require 'spec_helper'

feature 'User watches organization profile' do
  scenario 'with the right url' do
    pending
    organization = create :organization

    visit "/#{organization.slug}"
    expect(page).to have_content "#{organization.slug}"
    expect(current_path).to eq '{organization.slug}'
    should_not_have_subdomain "#{organization.slug}"
  end

  def should_not_have_subdomain(subdomain)
    current_host.should_not include subdomain
  end
end
