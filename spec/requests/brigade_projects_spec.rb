require 'spec_helper'

RSpec.describe "BrigadeProjects", :type => :request do
  describe "GET /brigade_projects" do
    it "works! (now write some real specs)" do
      get brigade_projects_path
      expect(response).to have_http_status(200)
    end
  end
end
