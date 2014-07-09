require 'spec_helper'

describe Member do

  describe "methods" do
    describe ".has_submitted_app?" do
      let(:member) { new_member }
      let(:challenge) { FactoryGirl.create(:challenge) }

      it "returns true when it has submitted an app for that challenge" do
        FactoryGirl.create(:entry, challenge: challenge, member: member)
        expect(member.has_submitted_app?(challenge)).to be true
      end

      it "returns false when it hasn't submitted an app for that challenge" do
        other_challenge = FactoryGirl.create(:challenge)
        expect(member.has_submitted_app?(other_challenge)).not_to be true
      end

      it "returns true when it has submitted a prototype for that challenge" do
        FactoryGirl.create(:entry, challenge: challenge, member: member, repo_url: 'http://mirepo.com', demo_url: 'http://midemo.com')
        expect(member.has_submitted_prototype_for_challenge?(challenge)).to be true
      end

      it "returns false when it hasn't submitted a prototype for that challenge" do
        FactoryGirl.create(:entry, challenge: challenge, member: member)
        expect(member.has_submitted_prototype_for_challenge?(challenge)).not_to be true
      end
    end
  end
end
