require 'spec_helper'

RSpec.describe "brigade_projects/show", :type => :view do
  before(:each) do
    @brigade_project = assign(:brigade_project, BrigadeProject.create!(
      :title => "Title",
      :description => "MyText",
      :brigade_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
