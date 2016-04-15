# require 'spec_helper'
#
# describe ReportCardDecorator do
#   report_card = FactoryGirl.build(:report_card)
#   let(:rcd) { ReportCardDecorator.new(report_card.id) }
#
#   describe 'methods' do
#     describe '#grade_process' do
#       it 'not return N/A if there is a grade and criterion' do
#         expect(rcd.grade_process(2, 1)).not_to eq 'N/A'
#       end
#     end
#   end
# end
