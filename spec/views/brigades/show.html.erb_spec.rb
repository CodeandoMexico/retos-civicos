require 'spec_helper'

describe "brigades/show" do
  before(:each) do
    @brigade = assign(:brigade, stub_model(Brigade,
      :zip_code => "Zip Code",
      :city => "City",
      :state => "State",
                                           :locality => "Locality",
      :description => "MyText",
      :calendar_url => "Calendar Url",
      :slack_url => "Slack Url",
      :github_url => "Github Url",
      :facebook_url => "Facebook Url",
      :twitter_url => "Twitter Url",
      :header_image_url => "Header Image Url",
      :user => nil,
      :deactivated => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Zip Code/)
    rendered.should match(/City/)
    rendered.should match(/State/)
    rendered.should match(/Locality/)
    rendered.should match(/MyText/)
    rendered.should match(/Calendar Url/)
    rendered.should match(/Slack Url/)
    rendered.should match(/Github Url/)
    rendered.should match(/Facebook Url/)
    rendered.should match(/Twitter Url/)
    rendered.should match(/Header Image Url/)
  end
end
