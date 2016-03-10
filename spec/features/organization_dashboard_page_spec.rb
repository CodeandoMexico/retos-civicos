require 'spec_helper'

feature "Organization Dashboard" do
  scenario "Can see subscribers list" do
    organization = new_organization

    sign_in_organization_admin(organization.user)
    create_list :subscriber, 3, organization: organization
    visit subscribers_list_organization_path(organization)

    Subscriber.all.each do |sub|
      page.should have_content sub.email
    end

    visit "/#{organization.id}"
    visit "/-1"
  end
end
