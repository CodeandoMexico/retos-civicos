require "spec_helper"

RSpec.describe BrigadeProjectsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/brigade_projects").to route_to("brigade_projects#index")
    end

    it "routes to #new" do
      expect(:get => "/brigade_projects/new").to route_to("brigade_projects#new")
    end

    it "routes to #show" do
      expect(:get => "/brigade_projects/1").to route_to("brigade_projects#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/brigade_projects/1/edit").to route_to("brigade_projects#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/brigade_projects").to route_to("brigade_projects#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/brigade_projects/1").to route_to("brigade_projects#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/brigade_projects/1").to route_to("brigade_projects#destroy", :id => "1")
    end

  end
end
