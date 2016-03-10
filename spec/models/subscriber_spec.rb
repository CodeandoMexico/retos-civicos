require 'spec_helper'

describe Subscriber do
  describe "validations" do

    it "Should not allow duplicate emails" do
      organization = FactoryGirl.create(:organization)
      FactoryGirl.create(:subscriber, email: "miguel@test.com", organization_id: organization.id)
      subscriber = FactoryGirl.build(:subscriber, email: "miguel@test.com", organization_id: organization.id)
      subscriber.should_not be_valid
    end
  end
end
