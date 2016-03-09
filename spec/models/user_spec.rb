require 'spec_helper'

describe User do

  describe "methods" do
    describe ".find_or_build_with_omniauth" do
      it "creates a user when email is not present" do
        info = double(name: "adrian", nickname: "hola", email: "myemail@hola.com")
        user = User.find_or_build_with_omniauth(info)

        expect(user.email).to eq("myemail@hola.com")
      end

      it "returns existing user with matching email" do
        user = FactoryGirl.create(:user)
        info = double(email: user.email)
        retrieved_user = User.find_or_build_with_omniauth(info)
        expect(user.email).to eq retrieved_user.email
      end
    end
  end
end
