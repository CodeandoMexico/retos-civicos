require 'spec_helper'

describe EntryDecorator do
  let!(:entry) { FactoryGirl.create(:entry) }
  let!(:ed) { EntryDecorator.new(entry) }

  describe 'methods' do
    describe '#owner_name' do
      it 'return the email if name is not available' do
        entry.member.name = nil
        expect(ed.owner_name).to eq entry.member.email
      end
    end

    describe '#score' do
      it 'return not available if not finished evaluating' do
        expect(ed.score).not_to eq I18n.t('entries.not_available')
      end
    end
  end
end
