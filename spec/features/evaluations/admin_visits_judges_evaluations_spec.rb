require 'spec_helper'

feature 'Admin enters evaluations panel and' do
  attr_reader :judges, :evaluations, :challenge_with_criteria, :challenge_with_no_criteria,
              :challenge_with_no_judges, :entries, :evaluation_with_criteria


  before do
    # users
    organization = create :organization
    admin = create :user, userable: organization
    @judges = create_list(:judge, 3)

    # different challenges types
    @challenge_with_no_criteria = create :challenge, organization: organization
    @challenge_with_no_judges = create :challenge, :with_criteria, organization: organization
    @challenge_with_criteria = create :challenge, :with_criteria, title: 'Challenge with evaluations', organization: organization

    # different evaluations
    @evaluations = @judges.map { |judge| create(:evaluation, challenge: challenge_with_criteria, judge: judge) }

    @entries = entries_with_different_members(3, challenge_with_criteria)
    sign_in_organization_admin(admin)
  end

  scenario 'clicks on a judge who has been accepted in an evaluation with no report cards' do
    visit_judge_path(judges.first)
    expect(page).to have_content I18n.t('dashboard.judges.show.no_report_cards_available_for_this_evaluation')
  end

  scenario 'clicks on a judge who has been accepted in an evaluation with three report cards' do
    report_cards = evaluate_all_entries_with(evaluations[0], entries, 5)

    visit_judge_path(judges.first)
    expect_page_to_have_all_entries_info(report_cards)
    expect(page).to_not have_content I18n.t('dashboard.judges.show.no_report_cards_available_for_this_evaluation')
  end

  scenario 'it displays an empty evaluations message when no criterias has been defined for this challenge.' do
    visit_judges_challenge_path_for(challenge_with_no_criteria)
    expect(page).to have_content I18n.t('dashboard.judges.index.no_criteria_has_been_defined_for_this_challenge')
  end

  scenario 'it display no judges have been selected to evaluate this challenge' do
    visit_judges_challenge_path_for(challenge_with_no_judges)
    expect(page).to have_content I18n.t('dashboard.judges.index.no_judges_have_been_selected_to_evaluate_this_challenge')
    save_and_open_page
  end

  scenario 'displays status of the different judges that have evaluated their entries' do
    judges_evaluate_entries
    visit_judges_challenge_path_for(challenge_with_criteria)
    expect_page_to_have_all_evaluations_content
  end

  def judges_evaluate_entries
    evaluate_all_entries_with(evaluations[0], entries, 5, entries.length)
    evaluate_all_entries_with(evaluations[1], entries, 4, 1)
    evaluate_all_entries_with(evaluations[2], entries, 3, 0)
  end

  def expect_page_to_have_all_evaluations_content
    I18n.t('evaluations.status.has_not_started')
    I18n.t('evaluations.status.still_evaluating', entries_evaluated: 1, total_entries: entries.length)
    I18n.t('evaluations.status.finished')
  end

  def expect_page_to_have_all_entries_info(report_cards)
    report_cards.each do |r|
      expect(page).to have_content r.entry.name
      expect(page).to have_content r.entry.description
      expect(page).to have_content r.total_score
    end
  end

  def visit_judges_challenge_path_for(challenge)
    visit dashboard_path
    click_on 'Jurado'
    click_link challenge.title
  end

  def visit_judge_path(judge)
    visit dashboard_path
    click_on 'Jurado'
    click_link "judge_#{judge.id}"
  end
end
