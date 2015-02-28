require 'spec_helper'

feature 'Organization admin filters entries' do
  attr_reader :organization, :accepted_entry, :not_accepted_entry

  before do
    @organization = create :organization
    challenge = create :challenge, organization: organization
    member_one = create :member
    member_two = create :member
    @accepted_entry = create :entry, :accepted, challenge: challenge, member: member_one
    @not_accepted_entry = create :entry, challenge: challenge, member: member_two
  end

  scenario 'with: received' do
    sign_in_organization_admin(organization.admin)
    visit dashboard_entries_path
    click_filter 'Recibidas'

    current_filter_should_be 'Recibidas'
    received_entries_count_should_eq 2
    accepted_entries_count_should_eq 1

    expect(page).to have_content accepted_entry.name
    expect(page).to have_content not_accepted_entry.name
  end

  scenario 'with: accepted' do
    sign_in_organization_admin(organization.admin)
    visit dashboard_entries_path
    click_filter 'Aceptadas'

    current_filter_should_be 'Aceptadas'
    received_entries_count_should_eq 2
    accepted_entries_count_should_eq 1

    expect(page).to have_content accepted_entry.name
    expect(page).to_not have_content not_accepted_entry.name
  end

  def click_filter(text)
    click_link text
  end

  def current_filter_should_be(text)
    page.should have_content text
  end

  def received_entries_count_should_eq(count)
    page.should have_content count.to_s
  end

  def accepted_entries_count_should_eq(count)
    page.should have_content count.to_s
  end
end
