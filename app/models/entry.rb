class Entry < ActiveRecord::Base
  include Reportable

  attr_accessible :image, :live_demo_url, :idea_url, :name, :description, :member_id, :url, :technologies, :letter_under_oath, :repo_url, :demo_url

  belongs_to :member
  belongs_to :challenge

  validates :name, :description, :idea_url, presence: true
  validate :idea_url_has_to_be_a_valid_url
  mount_uploader :letter_under_oath, LetterUnderOathUploader
  mount_uploader :image, EntryImageUploader
  serialize :technologies, Array
  before_validation :validate_technologies!

  def self.public
    where public: true
  end

  def self.accepted
    where accepted: true
  end

  def self.report_attributes
    [:id, :name, :challenge_title, :created_at, :description,
     :idea_url, :technologies_separated_by_commas, :member_name, :public?]
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

  def is_there_another_winner?
    Entry.find_by_winner(1).present? && !self.is_the_winner?
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
    errors.add(:idea_url, :invalid) unless uri.host.present?
  rescue URI::InvalidURIError
    errors.add(:idea_url, :invalid)
  end
end
