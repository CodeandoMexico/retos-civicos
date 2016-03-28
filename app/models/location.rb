class Location < ActiveRecord::Base
  attr_accessible :city, :locality, :state, :zip_code

  def self.search(location_query)
    return if location_query.blank?
    locations_found = Search.new(location_query)
    locations_found.uniq! { |location_found| [ location_found[:city], location_found[:state] ] }
    locations_found = locations_found[0..4]
    return locations_found.any? ? locations_found : { }
  end
end
