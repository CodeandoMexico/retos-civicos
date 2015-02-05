class Entry < ActiveRecord::Base
  include Reportable

  attr_accessible :image, :live_demo_url, :idea_url, :name, :description, :member_id, :url, :technologies, :letter_under_oath, :repo_url, :demo_url

  belongs_to :member
  belongs_to :challenge
  has_many :report_cards
  has_many :evaluations, through: :report_cards

  validates :name, :description, :idea_url, presence: true
  validate :idea_url_has_to_be_a_valid_url
  mount_uploader :letter_under_oath, LetterUnderOathUploader
  mount_uploader :image, EntryImageUploader
  serialize :technologies, Array
  before_validation :validate_technologies!
  after_update :limit_3_winner_entries

  def self.public
    where public: true
  end

  def self.accepted
    where accepted: true
  end

  def self.report_attributes
    [:id, :name, :challenge_title, :created_at, :description,
     :idea_url, :technologies_separated_by_commas, :member_name,
     :member_id, :member_company, :member_email, :letter_under_oath_present?, :public?]
  end

  def limit_3_winner_entries
    if challenge.current_winners.count > 3
      fail 'En un reto solamente se pueden seleccionar hasta 3 ganadores'
    end
  end

  def is_invalid?
    !self.is_valid
  end

  def mark_as_valid!
    self.is_valid = true
  end

  def mark_as_invalid!
    self.is_valid = false
  end

  def publish!
    self.public = true
  end

  def accept!
    self.accepted = true
  end

  def member?(user)
    member == user.try(:userable)
  end

  def member_name
    member.name
  end

  def member_id
    member.id
  end

  def member_company
    member.company_name
  end

  def member_email
    member.email
  end

  def letter_under_oath_present?
    letter_under_oath.present?
  end

  def challenge_title
    challenge.title
  end

  def technologies_separated_by_commas
    technologies.join ', '
  end

  def technologies_options
    ENTRY_TECHNOLOGIES
  end

  def is_the_winner?
    self.winner == 1
  end

  def more_than_3_winners?
    challenge.entries.where(winner: 1).count > 3
  end

  def select_as_winner
    self.winner = 1
  end

  def remove_as_winner
    self.winner = nil
  end

  private

  def validate_technologies!
    self.technologies = technologies.select do |technology|
      technology.present? && technologies_options.values.flatten.include?(technology)
    end
  end

  def idea_url_has_to_be_a_valid_url
    uri = URI(self.idea_url)
    uri = URI("http://#{uri}") if uri.scheme.nil?
    Net::HTTP.get_response(uri).is_a?(Net::HTTPSuccess)
    errors.add(:idea_url, :invalid) unless uri.host.present?
  rescue URI::InvalidURIError
    errors.add(:idea_url, :invalid)
  rescue SocketError
    errors.add(:idea_url, :invalid)
  end
end
