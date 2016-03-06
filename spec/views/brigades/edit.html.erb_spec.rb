require 'spec_helper'

describe "brigades/edit" do
  before(:each) do
    @brigade = assign(:brigade, stub_model(Brigade,
      :name => "MyString",
      :description => "MyText",
      :user => nil
    ))
  end

  it "renders the edit brigade form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", brigade_path(@brigade), "post" do
      assert_select "input#brigade_name[name=?]", "brigade[name]"
      assert_select "textarea#brigade_description[name=?]", "brigade[description]"
      assert_select "input#brigade_user[name=?]", "brigade[user]"
    end
  end
end
