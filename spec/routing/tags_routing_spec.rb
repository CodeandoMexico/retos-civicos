require "spec_helper"

RSpec.describe TagsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tags").to route_to("tags#index", :locale => "es")
    end

    it "routes to #new" do
      expect(:get => "/tags/new").to route_to("tags#new", :locale => "en")
    end

    it "routes to #show" do
      expect(:get => "/tags/1").to route_to("tags#show", :id => "1", :locale => "es")
    end

    it "routes to #edit" do
      expect(:get => "/tags/1/edit").to route_to("tags#edit", :id => "1", :locale => "en")
    end

    it "routes to #create" do
      expect(:post => "/tags").to route_to("tags#create", :locale => "es")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tags/1").to route_to("tags#update", :id => "1", :locale => "es")
    end

    it "routes to #destroy" do
      expect(:delete => "/tags/1").to route_to("tags#destroy", :id => "1", :locale => "es")
    end

  end
end
