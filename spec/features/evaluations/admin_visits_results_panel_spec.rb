require 'spec_helper'

feature 'Admin enters results panel and' do
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

  scenario 'it displays an empty evaluations message when no criterias has been defined for this challenge.' do
    visit_results_path_for(challenge_with_no_criteria)
    expect(page).to have_content I18n.t('dashboard.report_cards.index.no_criteria_has_been_defined_for_this_challenge')
  end

  scenario 'it display no judges have been selected to evaluate this challenge' do
    visit_results_path_for(challenge_with_no_judges)
    expect(page).to have_content I18n.t('dashboard.report_cards.index.no_judges_have_been_selected_to_evaluate_this_challenge')
  end

  scenario 'shows a message that ranking cannot be computed because there are still judges left to evaluate entries' do
    judges_evaluate_some_entries_but_not_all_of_them
    visit_results_path_for(challenge_with_criteria)
    expect(page).to have_content I18n.t('dashboard.report_cards.index.not_all_judges_are_finished_evaluating')
  end

  scenario 'shows a message that ranking cannot be computed because there are still judges left to evaluate entries' do
    judges_evaluate_all_entries
    visit_results_path_for(challenge_with_criteria)
    expect(page).to have_content I18n.t('shared.show_ranking_summary.scores')
    expect_page_to_have_final_scores(entries)
  end

  def judges_evaluate_some_entries_but_not_all_of_them
    evaluate_all_entries_with(evaluations[0], entries, 5, entries.length)
    evaluate_all_entries_with(evaluations[1], entries, 4, 1)
    evaluate_all_entries_with(evaluations[2], entries, 3, 0)
  end

  def judges_evaluate_all_entries
    evaluate_all_entries_with(evaluations[0], entries, 5, entries.length)
    evaluate_all_entries_with(evaluations[1], entries, 4, entries.length)
    evaluate_all_entries_with(evaluations[2], entries, 3, entries.length)
  end

  def expect_page_to_have_final_scores(entries)
    # let's check that the method is howing a result coming from the entry method
    entries.each { |e| expect(page).to have_content e.final_score }
    # now let's check that it's the correct result
    expect(page).to have_content "80"
  end

  def expect_page_to_have_all_evaluations_content
    I18n.t('evaluations.status.has_not_started')
    I18n.t('evaluations.status.still_evaluating', entries_evaluated: 1, total_entries: entries.length)
    I18n.t('evaluations.status.finished')
  end

  def visit_results_path_for(challenge)
    visit dashboard_path
    click_on 'Resultados'
    click_link challenge.title
  end
end
