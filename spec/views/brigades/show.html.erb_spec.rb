require 'spec_helper'

describe 'brigades/show' do
  before(:each) do
    @brigade = assign(:brigade, stub_model(Brigade,
                                           location_id: '1',
                                           description: 'MyText',
                                           calendar_url: 'Calendar Url',
                                           slack_url: 'Slack Url',
                                           github_url: 'Github Url',
                                           facebook_url: 'Facebook Url',
                                           twitter_url: 'Twitter Url',
                                           header_image_url: 'Header Image Url',
                                           user: nil,
                                           deactivated: false
                                          ))
  end

  it 'renders attributes in <p> with correct translation' do
    pending
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Ubicación/)
    rendered.should match(/Descripción/)
    rendered.should match(/URL del Calendario:/)
    rendered.should match(/URL de Slack/)
    rendered.should match(/URL de Github/)
    rendered.should match(/URL de Facebook/)
    rendered.should match(/Url de Twitter/)
    rendered.should match(/URL de Imagen de Perfil/)
  end
end
