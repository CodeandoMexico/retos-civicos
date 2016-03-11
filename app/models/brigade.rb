class Brigade < ActiveRecord::Base
  require 'yaml'
  belongs_to :user
  attr_accessible :calendar_url, :city, :description, :facebook_url, :github_url, :header_image_url, :locality,
                  :slack_url, :state, :twitter_url, :user, :zip_code
  @zip_codes = YAML.load_file("#{Rails.root}/config/zip_codes.yml")

  def self.location_of_zip_code(zip_code)
    return @zip_codes[zip_code].present? ? @zip_codes[zip_code] : {}
  end

end
