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


  scenario 'submits an valid (csv) evaluation file for a challenge' do
    sign_in_user judge_with_evaluations
    visit_evaluation_panel

    submit_a_evaluation_file_with(
      challenge_title: challenge_with_evaluations.title,
      evaluation_file: evaluation_csv_file
    )
    expect(current_path).to eq evaluations_path
  end

  scenario 'submits an invalid (pdf) evaluation file for a challenge' do
    sign_in_user judge_with_evaluations
    visit_evaluation_panel

    submit_a_evaluation_file_with(
      challenge_title: challenge_with_evaluations.title,
      evaluation_file: evaluation_pdf_file
    )
    expect(current_path).to eq evaluation_path(evaluation)
  end

  def submit_a_evaluation_file_with(args)
    click_link args.fetch(:challenge_title)
    click_link 'Importar evaluación'
    expect(page).to have_content args.fetch(:challenge_title)


    attach_file 'evaluation_evaluation_file', args.fetch(:evaluation_file)
    click_button 'Enviar'
  end

  def visit_evaluation_panel
    click_link 'Evaluaciones'
    expect(current_path).to eq evaluations_path
  end

  def evaluation_csv_file
    "#{Rails.root}/spec/fixtures/dummy.csv"
  end

  def evaluation_pdf_file
    "#{Rails.root}/spec/fixtures/dummy.pdf"
  end
end
