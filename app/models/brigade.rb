class Brigade < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  validates :location_id, presence: true
  validates :user_id, presence: true
  validates :description, length: { maximum: 500 }
  validates :calendar_url, length: { maximum: 500 }, url: true, allow_blank: true
  validates :slack_url, length: { maximum: 67 }, url: true, allow_blank: true, slack_url: true
  validates :facebook_url, length: { maximum: 500 }, url: true, allow_blank: true, facebook_url: true
  validates :github_url, length: { maximum: 500 }, url: true, allow_blank: true, github_url: true
  validates :twitter_url, length: { maximum: 40 }, url: true, allow_blank: true, twitter_url: true
  validates :header_image_url, length: { maximum: 500 }, url: true, allow_blank: true, image_url: true
  validates :deactivated, inclusion: { in: [true, false] }, exclusion: { in: [nil] }
  attr_accessible :calendar_url, :description, :facebook_url, :github_url, :header_image_url, :location_id, :slack_url,
                  :twitter_url, :user
end
