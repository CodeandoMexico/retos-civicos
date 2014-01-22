require 'spec_helper'

describe Subscriber do
  describe "validations" do
    it { should allow_value('adrian.rangel@codeandomexico.org').for(:email) }
    it { should_not allow_value('hola@.23','hola.23','@.com').for(:email) }

    it "Should not allow duplicate emails" do
      organization = FactoryGirl.create(:organization)
      FactoryGirl.create(:subscriber, email: "miguel@test.com", organization_id: organization.id)
      subscriber = FactoryGirl.build(:subscriber, email: "miguel@test.com", organization_id: organization.id)
      subscriber.should_not be_valid
    end
  end
end
