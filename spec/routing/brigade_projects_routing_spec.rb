require "spec_helper"

RSpec.describe BrigadeProjectsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/brigade_projects").to route_to("brigade_projects#index", :locale => "es")
    end

    it "routes to #new" do
      expect(:get => "/brigade_projects/new").to route_to("brigade_projects#new", :locale => "en")
    end

    it "routes to #show" do
      expect(:get => "/brigade_projects/1").to route_to("brigade_projects#show", :id => "1", :locale => "es")
    end

    it "routes to #edit" do
      expect(:get => "/brigade_projects/1/edit").to route_to("brigade_projects#edit", :id => "1", :locale => "en")
    end

    it "routes to #create" do
      expect(:post => "/brigade_projects").to route_to("brigade_projects#create", :locale => "es")
    end

    it "routes to #update via PUT" do
      expect(:put => "/brigade_projects/1").to route_to("brigade_projects#update", :id => "1", :locale => "es")
    end

    it "routes to #destroy" do
      expect(:delete => "/brigade_projects/1").to route_to("brigade_projects#destroy", :id => "1", :locale => "es")
    end

  end
end
