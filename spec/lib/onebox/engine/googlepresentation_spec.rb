require 'spec_helper'

describe Onebox::Engine::GooglePresentationOnebox do
  let(:link) { 'https://docs.google.com/presentation/d/1FdgQlDjvFDdEKjhx_Evkk12hoqrfNQf3vQDzrX-2ZKc/' }
  let(:html) { described_class.new(link).to_html }

  it 'has the URL to the resource' do
    expect(html).to include('iframe')
    expect(html).to include(link)
  end
end
