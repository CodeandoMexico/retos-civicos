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
    click_filter 'recibidas'

    current_filter_should_be 'recibidas'
    received_entries_count_should_eq 2
    accepted_entries_count_should_eq 1
    list_should_show not_accepted_entry
    list_should_show accepted_entry
  end

  scenario 'with: accepted' do
    sign_in_organization_admin(organization.admin)
    visit dashboard_entries_path
    click_filter 'aceptadas'

    current_filter_should_be 'aceptadas'
    received_entries_count_should_eq 2
    accepted_entries_count_should_eq 1
    list_should_show accepted_entry
    list_should_not_show not_accepted_entry
  end

  def click_filter(text)
    click_link text
  end

  def list_should_show(entry)
    page.should have_css "#entry_#{entry.id}"
  end

  def list_should_not_show(entry)
    page.should_not have_css "#entry_#{entry.id}"
  end

  def current_filter_should_be(text)
    within "#entries_filters .active" do
      page.should have_content text
    end
  end

  def received_entries_count_should_eq(count)
    within "#received_entries_count" do
      page.should have_content count.to_s
    end
  end

  def accepted_entries_count_should_eq(count)
    within "#accepted_entries_count" do
      page.should have_content count.to_s
    end
  end
end
