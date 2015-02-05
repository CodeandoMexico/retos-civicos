require 'spec_helper'

feature 'Judge enters the evaluations panel and' do
  attr_reader :organization, :challenge, :judge, :evaluation

  before do
    @organization = create :organization
    @challenge = create :challenge, organization: organization
    @judge = create :judge

    @evaluation = create :evaluation, challenge: @challenge, judge: @judge

    sign_in_user(@judge)
  end

  scenario 'starts a evaluating a challenge.' do

  end

  scenario 'starts a evaluating when a challenge has no criteria been set.' do
    click_on I18n.t('evaluations.index.start_evaluation')

    expect(page).to have_content I18n.t('flash.judge.criteria_has_not_been_set_for_this_challenge', email: organization.email)
  end
end
