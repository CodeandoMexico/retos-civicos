# A Brigade object represents a CodeandoMexico Brigade.
# Can be created by a user and deactivated by an administrator
# or the user who created it.

class Brigade < ActiveRecord::Base
  require 'time_ago_in_words'
  belongs_to :user
  belongs_to :location
  has_many :brigade_users
  has_many :users, through: :brigade_users
  has_many :brigade_projects
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

  def followers
    users
  end

  def organizer
    user
  end

  def num_members
    users.count + 1
  end

  def founding_date
    created_at.strftime('%d-%m-%y')
  end

  def brigade_since_formatter
    base_string = created_at.ago_in_words
    base_string = base_string.slice(0..(base_string.index(' and'))) if base_string.index(' and').present?
    base_string = base_string.gsub('second', 'segundo').gsub('minute', 'minuto').gsub('hour', 'hora').gsub('day', 'día').gsub('month', 'mes').gsub('year', 'año').gsub('ago', '')
    "#{I18n.t('brigades.founded')} #{base_string}"
  end

  def self.search(brigade_query)
    if brigade_query.blank?
      locations_found = Brigade.all.map(&:location_id)
    else
      brigade_query = brigade_query.downcase
      locations_found = Search.new(brigade_query).pluck(:searchable_id)
    end
    brigades_found = Brigade.where(location_id: locations_found)
    brigades_found.each do |brigade_found|
      brigade_found['city'] = brigade_found.location.city.titleize
      brigade_found['state'] = brigade_found.location.state.titleize
      brigade_found['color'] = '#' + [0, rand(100), rand(100), 180].sort.each_cons(2).map { |a, b| '%02x' % (32 + b - a) }.join
      brigade_found['num_hackers'] = "#{ActionController::Base.helpers.pluralize(brigade_found.users.count + 1, I18n.t('brigades.member')).downcase}"
      brigade_found['brigade_since'] = brigade_found.brigade_since_formatter
    end
    brigades_found.any? ? brigades_found : { 'message' => "#{I18n.t('brigades.index.no_brigades_match_search')} <a href='brigades/new' class='new-brigade-link-text'>#{I18n.t('brigades.index.create_brigade')}</a>" }.to_json
  end
end
