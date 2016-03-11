require 'spec_helper'

describe Authentication do

  describe "methods" do

    describe ".find_for_provider_oauth" do
      it "Should successfully log in the user" do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        auth_obj = OmniAuth.config.mock_auth[:facebook]
        auth_obj.stub(:provider) { "facebook" }
        auth_obj.stub(:uid) { "25073877" }
        auth_obj.stub_chain(:info, :name).and_return("Javier")
        auth_obj.stub_chain(:info, :nickname).and_return("Javi")
        auth_obj.stub_chain(:info, :email).and_return('joe@bloggs.com')
        auth_obj.stub_chain(:info, :image).and_return('http://graph.facebook.com/1234567/picture?type=square')
        auth_obj.stub_chain(:info, :location).and_return('Palo Alto, California')
        auth_obj.stub_chain(:info, :urls).and_return('http://www.facebook.com/jbloggs')
        Authentication.find_for_provider_oauth(auth_obj)
      end
    end
  end
end
