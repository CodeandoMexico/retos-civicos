require 'spec_helper'

feature 'Judge enters the evaluations panel and' do
  attr_reader :organization, :challenge_with_no_criteria, :challenge_with_criteria, :judge, :evaluation

  before do
    @judge = create :judge
    @organization = create :organization
    @challenge_with_no_criteria = create :challenge, organization: organization
    @challenge_with_criteria = create :challenge, :with_criteria, organization: organization

    @evaluation = create :evaluation, challenge: @challenge_with_no_criteria, judge: @judge

    sign_in_user(@judge)
  end

  scenario 'starts a evaluating a challenge.' do
    # for this scenario we're using a challenge_with_criteria
    click_on I18n.t('evaluations.index.start_evaluation')

    # t
  end

  scenario 'starts a evaluating when a challenge has no criteria been set.' do
    # for this scenario we're using a challenge_with_no_criteria
    click_on I18n.t('evaluations.index.start_evaluation')
    expect(page).to have_content I18n.t('flash.judge.criteria_has_not_been_set_for_this_challenge', email: organization.email)
  end
end
