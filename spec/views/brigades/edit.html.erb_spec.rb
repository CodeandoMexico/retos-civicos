require 'spec_helper'

describe 'brigades/edit' do
  before(:each) do
    @brigade = assign(:brigade, stub_model(Brigade,
                                           location_id: '1',
                                           description: 'MyText',
                                           calendar_url: 'MyString',
                                           slack_url: 'MyString',
                                           github_url: 'MyString',
                                           facebook_url: 'MyString',
                                           twitter_url: 'MyString',
                                           header_image_url: 'MyString',
                                           user: nil,
                                           deactivated: false
                                          ))
  end

  it 'renders the edit brigade form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', brigade_path(@brigade), 'post' do
      assert_select 'input#brigade_location_id[name=?]', 'brigade[location_id]'
      assert_select 'textarea#brigade_description[name=?]', 'brigade[description]'
      assert_select 'input#brigade_calendar_url[name=?]', 'brigade[calendar_url]'
      assert_select 'input#brigade_slack_url[name=?]', 'brigade[slack_url]'
      assert_select 'input#brigade_github_url[name=?]', 'brigade[github_url]'
      assert_select 'input#brigade_facebook_url[name=?]', 'brigade[facebook_url]'
      assert_select 'input#brigade_twitter_url[name=?]', 'brigade[twitter_url]'
      assert_select 'input#brigade_header_image_url[name=?]', 'brigade[header_image_url]'
    end
  end
end
