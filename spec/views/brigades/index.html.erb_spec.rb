require 'spec_helper'

describe 'brigades/index' do
  before(:each) do
    assign(:brigades, [
      stub_model(Brigade,
                 zip_code: 'Zip Code',
                 city: 'City',
                 state: 'State',
                 locality: 'Locality',
                 description: 'MyText',
                 calendar_url: 'Calendar Url',
                 slack_url: 'Slack Url',
                 github_url: 'Github Url',
                 facebook_url: 'Facebook Url',
                 twitter_url: 'Twitter Url',
                 header_image_url: 'Header Image Url',
                 user: nil,
                 deactivated: false
                ),
      stub_model(Brigade,
                 zip_code: 'Zip Code',
                 city: 'City',
                 state: 'State',
                 locality: 'Locality',
                 description: 'MyText',
                 calendar_url: 'Calendar Url',
                 slack_url: 'Slack Url',
                 github_url: 'Github Url',
                 facebook_url: 'Facebook Url',
                 twitter_url: 'Twitter Url',
                 header_image_url: 'Header Image Url',
                 user: nil,
                 deactivated: false
                )
    ])
  end

  it 'renders a list of brigades' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'tr>td', text: 'Zip Code'.to_s, count: 2
    assert_select 'tr>td', text: 'City'.to_s, count: 2
    assert_select 'tr>td', text: 'State'.to_s, count: 2
    assert_select 'tr>td', text: 'Locality'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'Calendar Url'.to_s, count: 2
    assert_select 'tr>td', text: 'Slack Url'.to_s, count: 2
    assert_select 'tr>td', text: 'Github Url'.to_s, count: 2
    assert_select 'tr>td', text: 'Facebook Url'.to_s, count: 2
    assert_select 'tr>td', text: 'Twitter Url'.to_s, count: 2
    assert_select 'tr>td', text: 'Header Image Url'.to_s, count: 2
  end
end
