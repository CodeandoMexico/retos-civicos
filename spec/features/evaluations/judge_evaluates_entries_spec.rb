require 'spec_helper'

feature 'Judge enters the evaluations panel and' do
  attr_reader :organization, :evaluation_with_no_criteria,
               :evaluation_with_criteria, :judge, :evaluation, :entries

  before do
    @judge = create :judge
    @organization = create :organization
    challenge_with_no_criteria = create :challenge, organization: organization
    challenge_with_criteria = create :challenge, :with_criteria, organization: organization

    @entries = entries_with_different_members(3, challenge_with_criteria)
    @entries.concat invalid_entries_in_challenge(2, challenge_with_criteria)
    @evaluation_with_no_criteria = create :evaluation, challenge: challenge_with_no_criteria, judge: @judge
    @evaluation_with_criteria = create :evaluation, challenge: challenge_with_criteria, judge: @judge

    # manually create the report cards
    @evaluation_with_criteria.initialize_report_cards

    sign_in_user(@judge)
  end

  scenario 'lists the first entry for a challenge.' do
    # for this scenario we're using a challenge_with_criteria
    click_on evaluation_with_criteria.challenge.title

    # minus two 'cause there are two invalid entries
    expect(evaluation_with_criteria.report_cards.count).to eq entries.length - 2
    expect(page).to have_content entries.first.name
  end

  scenario 'starts a evaluating the all entries for a challenge.' do
    # for this scenario we're using a challenge_with_criteria
    click_on evaluation_with_criteria.challenge.title

    expect(page).to have_content "0%"

    evaluate(entries[0], 3)
    expect(page).to have_content I18n.t('report_cards.evaluation_has_been_saved_successfully')
    expect(page).to have_content 3

    page_should_not_have_prev_entry_link
    expect(page).to have_content "34%"
    navigate_to_next_entry

    # this entry will have comment
    comments = 'Example comments'
    evaluate(entries[1], 4, comments: comments)
    expect(page).to have_content I18n.t('report_cards.evaluation_has_been_saved_successfully')
    expect(page).to have_content 4

    expect(page).to have_content "67%"
    page_should_have_prev_entry_link
    page_should_have_next_entry_link

    navigate_to_next_entry

    # this entry will have feedback
    feedback = 'Example feedback'
    evaluate(entries[2], 5, feedback: feedback)
    expect(page).to have_content I18n.t('shared.show_ranking_summary.scores')
  end

  scenario 'he sets an entry invalid, then a judge starts a evaluating all entries for a challenge.' do
    Capybara.using_driver :selenium do
      # let's set an entry as invalid
      mark_entry_as_invalid(entries[0])

      # for this scenario we're using a challenge_with_criteria
      sign_in_user(@judge)
      find('a', text: evaluation_with_criteria.challenge.title).click

      # let's check again for the report count
      expect(evaluation_with_criteria.report_cards.count).to eq entries.length - 3

      expect(page).to have_content "0%"
      evaluate(entries[1], 4)
      expect(page).to have_content I18n.t('report_cards.evaluation_has_been_saved_successfully')
      expect(page).to have_content 4

      expect(page).to have_content "50%"
      page_should_not_have_prev_entry_link
      page_should_have_next_entry_link
      navigate_to_next_entry
      evaluate(entries[2], 5)
      expect(page).to have_content I18n.t('shared.show_ranking_summary.scores')
    end

  end

  scenario 'starts a evaluating when a challenge has no criteria been set.' do
    # for this scenario we're using a challenge_with_no_criteria
    click_on evaluation_with_no_criteria.challenge.title
    expect(page).to have_content I18n.t('evaluations.index.no_evaluation_criteria', email: organization.email)
  end

  scenario 'sees a different description when admin changes the criteria' do
    Capybara.using_driver :selenium do
      admin_updates_criteria_definition
      sign_in_user(@judge)
      find('a', text: evaluation_with_criteria.challenge.title).click
      check_for_updated_criteria
    end
  end

  def mark_entry_as_invalid(entry)
    entry.mark_as_invalid!("An invalid reason message")
  end

  def check_for_updated_criteria
    10.times { |idx| expect(page).to have_content "New criteria #{idx+1}" }
  end

  def admin_updates_criteria_definition
    sign_in_user(organization)
    click_link 'Jurado'
    click_on "Acciones"
    click_link I18n.t('dashboard.judges.index.define_criteria')
    update_criteria_fields
    visit '/'
    click_link organization.admin.name, match: :first
    click_link 'Cerrar sesión'

  end

  def navigate_to_next_entry
    click_on I18n.t('evaluations.index.next_entry')
  end
end
