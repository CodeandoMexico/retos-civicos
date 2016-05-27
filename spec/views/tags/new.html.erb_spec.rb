require 'spec_helper'

RSpec.describe "tags/new", :type => :view do
  before(:each) do
    assign(:tag, Tag.new(
      :name => "MyString"
    ))
  end

  it "renders new tag form" do
    render

    assert_select "form[action=?][method=?]", tags_path, "post" do

      assert_select "input#tag_name[name=?]", "tag[name]"
    end
  end
end
