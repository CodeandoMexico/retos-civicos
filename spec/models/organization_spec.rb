require 'spec_helper'

describe Organization do
  describe 'methods' do
    let!(:organization) { FactoryBot.create(:organization, name: 'org_1') }
    describe '#accredit!' do
      it 'it should make accredit true.' do
        organization.accredit!
        expect(organization.accredited).to be true
      end
    end

    describe '#only_one_challenge?' do
      describe 'Given there are no challenges' do
        it 'should return false' do
          expect(organization.only_one_challenge?).to be false
        end
      end
    end

    describe '#submitted_app?' do
      it 'should return false' do
        expect(organization.submitted_app?(nil)).to be false
      end
    end

    describe '#to_s' do
      it 'should output the name if it has one' do
        expect(organization.to_s).to eq 'org_1'
      end
    end

    describe '#admin' do
      it 'should output the user who is its admin' do
        expect(organization.admin).to eq organization.user
      end
    end
  end
end
