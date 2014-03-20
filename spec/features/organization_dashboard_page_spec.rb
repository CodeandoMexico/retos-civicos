require 'spec_helper'

feature "Organization Dashboard" do

  let!(:organization) { new_organization }

  background do
    sign_in_user(organization.user, password: 'password')
  end

  scenario "Can see subscribers list" do
    FactoryGirl.create_list(:subscriber, 3, organization_id: organization.id)

    visit subscribers_list_organization_path(organization.id)

    Subscriber.all.each do |sub|
      page.should have_content sub.email
    end
  end

end
