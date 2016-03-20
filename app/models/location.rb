class Location < ActiveRecord::Base
  attr_accessible :city, :locality, :state, :zip_code

  def self.search(location_query)
    formed_query = 'zip_code LIKE :location_query OR locality LIKE :location_query OR city LIKE :location_query
    OR state LIKE :location_query'
    Location.where(formed_query, location_query: "%#{location_query}%")
  end
end
