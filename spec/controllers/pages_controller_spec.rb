require 'spec_helper'

describe PagesController do

  before(:all) do
    Rails.application.routes.draw { match ':controller(/:action)' }
  end
  after(:all) do
    Rails.application.reload_routes!
  end

  describe 'GET start_a_challenge' do
    it 'render aquila layout' do
      get :start_a_challenge
      expect(response).to render_template("aquila")
    end
  end

  describe 'GET about' do
    it 'render aquila layout' do
      get :about
      expect(response).to render_template("aquila")
    end
  end

  describe 'GET terms_of_service' do
    it 'render aquila layout' do
      get :terms_of_service
      expect(response).to render_template("aquila")
    end
  end

  describe 'GET privacy' do
    it 'render aquila layout' do
      get :privacy
      expect(response).to render_template("aquila")
    end
  end
end
