require 'spec_helper'

describe "brigades/new" do
  before(:each) do
    assign(:brigade, stub_model(Brigade,
      :zip_code => "MyString",
      :city => "MyString",
      :state => "MyString",
      :description => "MyText",
      :calendar_url => "MyString",
      :slack_url => "MyString",
      :github_url => "MyString",
      :facebook_url => "MyString",
      :twitter_url => "MyString",
      :header_image_url => "MyString",
      :user => nil,
      :deactivated => false
    ).as_new_record)
  end

  it "renders new brigade form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", brigades_path, "post" do
      assert_select "input#brigade_zip_code[name=?]", "brigade[zip_code]"
      assert_select "input#brigade_city[name=?]", "brigade[city]"
      assert_select "input#brigade_state[name=?]", "brigade[state]"
      assert_select "textarea#brigade_description[name=?]", "brigade[description]"
      assert_select "input#brigade_calendar_url[name=?]", "brigade[calendar_url]"
      assert_select "input#brigade_slack_url[name=?]", "brigade[slack_url]"
      assert_select "input#brigade_github_url[name=?]", "brigade[github_url]"
      assert_select "input#brigade_facebook_url[name=?]", "brigade[facebook_url]"
      assert_select "input#brigade_twitter_url[name=?]", "brigade[twitter_url]"
      assert_select "input#brigade_header_image_url[name=?]", "brigade[header_image_url]"
    end
  end
end
