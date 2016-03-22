class Location < ActiveRecord::Base
  attr_accessible :city, :locality, :state, :zip_code

  def self.search(location_query)
    return if location_query.blank?
    formed_query = 'unaccent(zip_code) ILIKE :location_query OR unaccent(locality) ILIKE :location_query
    OR unaccent(city) ILIKE :location_query OR unaccent(state) ILIKE :location_query
    OR zip_code ILIKE :location_query OR locality ILIKE :location_query OR city ILIKE :location_query
    OR state ILIKE :location_query'
    # locations_found = Location.where(formed_query, location_query: "%#{location_query.downcase}%").limit(5)
    locations_found = Search.new(location_query)
    return locations_found.exists? ? locations_found : { }
  end
end
