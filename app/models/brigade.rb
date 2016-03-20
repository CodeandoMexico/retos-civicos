class Brigade < ActiveRecord::Base
  belongs_to :user
  attr_accessible :calendar_url, :description, :facebook_url, :github_url, :header_image_url, :location, :slack_url,
                  :twitter_url, :user
end
