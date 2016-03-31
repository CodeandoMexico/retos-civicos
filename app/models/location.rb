class Location < ActiveRecord::Base
  has_one :brigade
  attr_accessible :city, :locality, :state, :zip_code

  def self.search(location_query)
    return if location_query.blank?
    location_query = location_query.downcase
    locations_found = Search.new(location_query)
    locations_found.uniq! { |location_found| [ location_found[:city], location_found[:state] ] }
    locations_found = locations_found[0..4]
    locations_found.each do |location_found|
      location_found['city'] = location_found['city'].titleize
      location_found['state'] = location_found['state'].titleize
    end
    return locations_found.any? ? locations_found : { }
  end
end
