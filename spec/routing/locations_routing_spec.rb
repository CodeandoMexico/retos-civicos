require 'spec_helper'

describe LocationController do
  it 'routes to #location_search' do
    get('/location_search/48400').should route_to('location#location_search', location_query: '48400', locale: 'es')
  end
  it 'routes to #location_name' do
    get('/location_name/1').should route_to('location#location_name', location_id: '1', locale: 'es')
  end
end