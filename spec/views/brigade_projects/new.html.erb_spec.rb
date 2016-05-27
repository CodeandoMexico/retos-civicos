require 'spec_helper'

RSpec.describe "brigade_projects/new", :type => :view do
  before(:each) do
    assign(:brigade_project, BrigadeProject.new(
      :title => "MyString",
      :description => "MyText",
      :brigade_id => 1
    ))
  end

  it "renders new brigade_project form" do
    render

    assert_select "form[action=?][method=?]", brigade_projects_path, "post" do

      assert_select "input#brigade_project_title[name=?]", "brigade_project[title]"

      assert_select "textarea#brigade_project_description[name=?]", "brigade_project[description]"

      assert_select "input#brigade_project_brigade[name=?]", "brigade_project[brigade]"
    end
  end
end
