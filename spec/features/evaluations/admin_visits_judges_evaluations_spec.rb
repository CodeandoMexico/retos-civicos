require 'spec_helper'

feature 'Admin enters evaluations panel and' do
  attr_reader :judge, :entries, :evaluation_with_criteria

  before do
    # users
    @judge = create :judge
    organization = create :organization
    admin = create :user, userable: organization

    # different challenges types
    challenge_with_criteria = create :challenge, :with_criteria, organization: organization

    # different evaluations
    @evaluation_with_criteria = create :evaluation, challenge: challenge_with_criteria, judge: @judge

    @entries = entries_with_different_members(3, challenge_with_criteria)
    sign_in_organization_admin(admin)
  end

  scenario 'clicks on a judge who has been accepted in an evaluation with no report cards' do
    visit_jury_path
    expect(page).to have_content I18n.t('dashboard.judges.show.no_report_cards_available_for_this_evaluation')
  end

  scenario 'clicks on a judge who has been accepted in an evaluation with three report cards' do
    report_cards = evaluate_all_entries_with(evaluation_with_criteria, entries, 5)

    visit_jury_path
    expect_page_to_have_all_entries_info(report_cards)
    expect(page).to_not have_content I18n.t('dashboard.judges.show.no_report_cards_available_for_this_evaluation')
  end

  def expect_page_to_have_all_entries_info(report_cards)
    report_cards.each do |r|
      expect(page).to have_content r.entry.name
      expect(page).to have_content r.entry.description
      expect(page).to have_content r.total_score
    end
  end

  def visit_jury_path
    visit dashboard_path
    click_on 'Jurado'
    click_link "judge_#{judge.id}"
  end
end
