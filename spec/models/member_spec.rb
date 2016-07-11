require 'spec_helper'

describe Member do
  describe 'methods' do
    let(:member) { new_member }
    let(:no_name_member) { FactoryGirl.create(:member, name: nil) }
    let(:no_identity_member) { FactoryGirl.create(:member, name: nil, nickname: nil) }
    let(:challenge) { FactoryGirl.create(:challenge) }

    describe '.submitted_app?' do
      it 'returns true when it has submitted an app for that challenge' do
        FactoryGirl.create(:entry, challenge: challenge, member: member)
        expect(member.submitted_app?(challenge)).to be true
      end

      it "returns false when it hasn't submitted an app for that challenge" do
        other_challenge = FactoryGirl.create(:challenge)
        expect(member.submitted_app?(other_challenge)).not_to be true
      end

      it 'returns true when it has submitted a prototype for that challenge' do
        FactoryGirl.create(:entry, challenge: challenge, member: member, repo_url: 'http://mirepo.com', demo_url: 'http://midemo.com')
        expect(member.submitted_prototype_for_challenge?(challenge)).to be true
      end

      it "returns false when it hasn't submitted a prototype for that challenge" do
        FactoryGirl.create(:entry, challenge: challenge, member: member)
        expect(member.submitted_prototype_for_challenge?(challenge)).not_to be true
      end
    end

    describe '#to_s?' do
      describe 'given member has name' do
        it 'should return name' do
          expect(member.to_s).to eq member.name
        end
      end

      describe 'given member has no name but has a nickname' do
        it 'should return nickname' do
          expect(no_name_member.to_s).to eq member.nickname
        end
      end

      describe 'given member has no name or nickname' do
        it 'should return nothing' do
          expect(no_identity_member.to_s).to eq ''
        end
      end
    end

    describe '#representative' do
      describe 'given member has name' do
        it 'should return name' do
          expect(member.representative).to eq member.name
        end
      end

      describe 'given member has no name but has a nickname' do
        it 'should return nickname' do
          expect(no_name_member.representative).to eq member.nickname
        end
      end

      describe 'given member has no name or nickname' do
        it 'should return nothing' do
          expect(no_identity_member.representative).to eq ''
        end
      end
    end
  end
end
