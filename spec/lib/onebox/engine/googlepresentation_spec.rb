require "spec_helper"

describe Onebox::Engine::GooglepresentationOnebox do
  let(:link) { "https://docs.google.com/presentation/d/1FdgQlDjvFDdEKjhx_Evkk12hoqrfNQf3vQDzrX-2ZKc/pub?start=false&loop=false&delayms=3000" }
  let(:html) { described_class.new(link).to_html }

  before do
    puts link
    puts html
    fake(link, response("name.response"))
    save_and_open_page
  end

  it "has the video's title" do
    expect(html).to include("title")
  end

  it "has the video's still shot" do
    expect(html).to include("photo.jpg")
  end

  it "has the video's description" do
    expect(html).to include("description")
  end

  it "has the URL to the resource" do
    expect(html).to include(link)
  end
end
