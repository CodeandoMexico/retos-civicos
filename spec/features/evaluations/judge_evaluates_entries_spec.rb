require 'spec_helper'

feature 'Judge enters the evaluations panel and' do
  attr_reader :organization, :evaluation_with_no_criteria,
               :evaluation_with_criteria, :judge, :evaluation, :entries

  before do
    @judge = create :judge
    @organization = create :organization
    challenge_with_no_criteria = create :challenge, organization: organization
    challenge_with_criteria = create :challenge, :with_criteria, organization: organization

    @evaluation_with_no_criteria = create :evaluation, challenge: challenge_with_no_criteria, judge: @judge
    @evaluation_with_criteria = create :evaluation, challenge: challenge_with_criteria, judge: @judge
    @entries = []
    3.times { |idx| @entries << create(:entry,
              challenge: challenge_with_criteria,
              member: new_member,
              name: "Propuesta #{idx}",
              description: "This is a description #{idx}",
              idea_url: 'http://mipropuesta.com',
              technologies: ['PHP', 'Rust'],
              created_at: Time.zone.local(2014,4,25,10,52,24)
            )}

    sign_in_user(@judge)
  end

  scenario 'lists the first entry for a challenge.' do
    # for this scenario we're using a challenge_with_criteria
    click_on evaluation_with_criteria.challenge.title

    expect(evaluation_with_criteria.challenge.entries.count).to eq entries.length
    expect(page).to have_content entries.first.name
  end

  scenario 'starts a evaluating the all entries for a challenge.' do
    # for this scenario we're using a challenge_with_criteria
    click_on evaluation_with_criteria.challenge.title
    set_criteria_fields_to 5

    click_on I18n.t('evaluations.evaluation_criteria.save_criteria')

    expect(page).to have_content I18n.t('report_cards.evaluation_has_ben_saved_successfully')
    click_on I18n.t('evaluations.index.next_entry')
    # raise evaluation_with_criteria.report_cards.inspect
    # raise ReportCard.pluck(:grades).inspect
    # save_and_open_page
  end

  scenario 'starts a evaluating when a challenge has no criteria been set.' do
    # for this scenario we're using a challenge_with_no_criteria
    click_on evaluation_with_no_criteria.challenge.title
    expect(page).to have_content I18n.t('evaluations.index.there_are_no_entries_to_evaluate_for_this_challenge', email: organization.email)
  end

  def set_criteria_fields_to(grade)
    10.times { |idx| all(:css, "#criteria__value")[idx].set(grade) }
  end
end
