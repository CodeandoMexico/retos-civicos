require 'spec_helper'
feature 'Judge' do
  attr_reader :judge_with_no_evaluations, :judge_with_evaluations, :challenge_without_evaluations, :challenge_with_evaluations, :evaluation
  before do
    @judge_with_no_evaluations = create :judge
    @judge_with_evaluations = create :judge

    organization = create :organization

    @challenge_without_evaluations = create :challenge, title: 'Challenge Without Evaluations', organization: organization
    @challenge_with_evaluations = create :challenge, title: 'Challenge With Evaluations', organization: organization
    @evaluation = create :evaluation, challenge: challenge_with_evaluations, judge: @judge_with_evaluations

    another_challenge_with_evaluations = create :challenge, title: 'Another Random Challenge That Also Has Evaluations', organization: organization
    create :evaluation, challenge: another_challenge_with_evaluations, judge: @judge_with_evaluations
  end

  scenario 'visits evaluation panel when there are no challenges' do
    sign_in_user judge_with_no_evaluations
    visit_evaluation_panel

    expect(page).to have_content "No tienes retos asignados"
  end

  scenario 'visits evaluation panel and there is a challenge to evaluate' do
    sign_in_user judge_with_evaluations
    visit_evaluation_panel

    expect(page).to have_content "Challenge With Evaluations"
  end

  def visit_evaluation_panel
    click_link 'Evaluaciones'
    expect(current_path).to eq evaluations_path
  end
end
