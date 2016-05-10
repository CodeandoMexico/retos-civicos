require 'spec_helper'

RSpec.describe "brigade_projects/index", :type => :view do
  before(:each) do
    assign(:brigade_projects, [
      BrigadeProject.create!(
        :title => "Title",
        :description => "MyText",
        :brigade => nil
      ),
      BrigadeProject.create!(
        :title => "Title",
        :description => "MyText",
        :brigade => nil
      )
    ])
  end

  it "renders a list of brigade_projects" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
