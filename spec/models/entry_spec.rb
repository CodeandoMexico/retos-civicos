require 'spec_helper'

describe Entry do
  let!(:active_ch) { FactoryGirl.create(:challenge, :with_criteria) }
  let!(:another_ch) { FactoryGirl.create(:challenge, :with_criteria) }
  let!(:judges) { FactoryGirl.create_list(:judge, 3) }

  it 'should show that there are no newly created report_cards' do
    entry = FactoryGirl.create(:entry, challenge:  active_ch)
    expect(ReportCard.count).to eq 0
  end

  it 'should show that a new report cards were generated for the created judges' do
    # this set of evaluations are for another challenge
    judges.map { |judge| create(:evaluation, challenge: another_ch, judge: judge) }

    # this evaluation are the ones that we are validating for
    evaluations = judges.map { |judge| create(:evaluation, challenge: active_ch, judge: judge) }
    entry = FactoryGirl.create(:entry, challenge:  active_ch)

    verify_new_report_cards(evaluations, entry)
  end
end

def verify_new_report_cards(evaluations, entry)
  expect(ReportCard.count).to eq 3
  expect(ReportCard.where(entry_id: entry.id).count). to eq 3
  evaluations.each do |e|
    expect(ReportCard.where(evaluation_id: e.id).count). to eq 1
  end
end
