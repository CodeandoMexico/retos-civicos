require 'spec_helper'

RSpec.describe "brigade_projects/edit", :type => :view do
  before(:each) do
    @brigade_project = assign(:brigade_project, BrigadeProject.create!(
      :title => "MyString",
      :description => "MyText",
      :brigade => nil
    ))
  end

  it "renders the edit brigade_project form" do
    render

    assert_select "form[action=?][method=?]", brigade_project_path(@brigade_project), "post" do

      assert_select "input#brigade_project_title[name=?]", "brigade_project[title]"

      assert_select "textarea#brigade_project_description[name=?]", "brigade_project[description]"

      assert_select "input#brigade_project_brigade[name=?]", "brigade_project[brigade]"
    end
  end
end
