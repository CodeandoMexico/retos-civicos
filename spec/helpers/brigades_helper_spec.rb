require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the BrigadesHelper. For example:
#
# describe BrigadesHelper do
#   describe 'string concat' do
#     it 'concats two strings with spaces' do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe BrigadesHelper do
  describe 'submit_button_text' do
    describe 'given user is creating a brigade' do
      it 'should return creation text' do
        f = {}
        f.stub_chain(:object, :new_record?).and_return(true)
        expect(submit_button_text(f)).to eq I18n.t('brigades.new.submit')
      end
    end
  end
end
