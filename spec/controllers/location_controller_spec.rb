require 'spec_helper'

describe LocationController do
  describe 'GET location_search' do
    it 'calls the model function location_search' do
      expect(Location).to receive(:search).with('48400')
      get :location_search, :location_query => '48400', 'locale' => 'en', :format => :json
    end

    it 'calls the model function location_search' do
      get :location_search, :location_query => '48400', 'locale' => 'en', :format => :json
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end

  describe 'GET location_name' do
    it 'calls the model function title' do
      expect(Location).to receive(:title).with('1')
      get :location_name, :location_id => '1', 'locale' => 'en', :format => :json
    end

    it 'calls the model function title' do
      get :location_name, :location_id => '1', 'locale' => 'en', :format => :json
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
