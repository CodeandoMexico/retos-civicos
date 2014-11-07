require 'spec_helper'
feature 'Judge' do
  attr_reader :judge
  before do
    @judge = create :judge
    sign_in_user @judge
  end

  scenario 'logs in the system' do
    expect(current_path).to eq judge_path(judge)
  end

  scenario 'visits evaluation panel' do
    visit_evaluation_panel
    expect(current_path).to eq judge_evaluations_path(judge)
    expect(page).to have_content "Mis retos como jurado"
  end

  def visit_evaluation_panel
    click_link 'Evaluaciones'
  end
end
