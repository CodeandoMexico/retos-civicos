require 'spec_helper'

describe "brigades/new" do
  before(:each) do
    assign(:brigade, stub_model(Brigade,
      :name => "MyString",
      :description => "MyText",
      :user => nil
    ).as_new_record)
  end

  it "renders new brigade form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", brigades_path, "post" do
      assert_select "input#brigade_name[name=?]", "brigade[name]"
      assert_select "textarea#brigade_description[name=?]", "brigade[description]"
      assert_select "input#brigade_user[name=?]", "brigade[user]"
    end
  end
end
