require "spec_helper"

describe BrigadesController do
  describe "routing" do

    it "routes to #index" do
      get("/brigades").should route_to("brigades#index")
    end

    it "routes to #new" do
      get("/brigades/new").should route_to("brigades#new")
    end

    it "routes to #show" do
      get("/brigades/1").should route_to("brigades#show", :id => "1")
    end

    it "routes to #edit" do
      get("/brigades/1/edit").should route_to("brigades#edit", :id => "1")
    end

    it "routes to #create" do
      post("/brigades").should route_to("brigades#create")
    end

    it "routes to #update" do
      put("/brigades/1").should route_to("brigades#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/brigades/1").should route_to("brigades#destroy", :id => "1")
    end

  end
end
