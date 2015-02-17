require 'spec_helper'

feature 'Admin enters evaluations panel and' do
  attr_reader :judge, :challenge_with_criteria

  before do
    # users
    @judge = create :judge
    organization = create :organization
    admin = create :user, userable: organization

    # different challenges types
    # challenge_with_no_criteria = create :challenge, organization: organization
    challenge_with_criteria = create :challenge, :with_criteria, organization: organization

    # different evaluations
    # @evaluation_with_no_criteria = create :evaluation, challenge: challenge_with_no_criteria, judge: @judge
    @evaluation_with_criteria = create :evaluation, challenge: challenge_with_criteria, judge: @judge

    @entries = entries_with_different_members(3, challenge_with_criteria)
    sign_in_organization_admin(admin)
  end

  scenario 'clicks on a judge' do
    visit dashboard_path
    click_on 'Jurado'
    # click_link challenge_with_criteria

    click_link "judge_#{judge.id}"
    save_and_open_page
  end
end
