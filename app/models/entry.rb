class Entry < ActiveRecord::Base
  include Reportable

  attr_accessible :image, :live_demo_url, :idea_url, :name, :description,
                  :member_id, :url, :technologies, :repo_url, :demo_url,
                  :invalid_reason

  belongs_to :member
  belongs_to :challenge
  has_many :report_cards, order: 'id ASC'
  has_many :evaluations, through: :report_cards

  validates :name, :description, :idea_url, presence: true
  validate :idea_url_has_to_be_a_valid_url
  mount_uploader :image, EntryImageUploader
  serialize :technologies, Array
  before_validation :validate_technologies!
  after_update :limit_3_winner_entries
  after_create :initialize_report_cards

  def comments
    # Fetch each report card comments and validate they don't not have blank strings.
    report_cards.where('comments IS NOT NULL').map(&:comments)
  end

  def feedback
    # Fetch each report card feedback and validate they don't not have blank strings.
    report_cards.where('feedback IS NOT NULL').where("feedback != ''").map(&:feedback)
  end

  def evaluated?
    report_cards.map(&:criteria_and_grades_are_valid?).all?
  end

  def editable?
    member.is_able_to_edit_entry?(challenge) || member.is_able_to_submit_a_prototype?(challenge)
  end

  def self.public
    where public: true
  end

  def self.accepted
    where accepted: true
  end

  def self.report_attributes
    [:id, :name, :challenge_title, :created_at, :description,
     :idea_url, :technologies_separated_by_commas, :member_name,
     :member_id, :member_email, :public?]
  end

  def final_score
    # This method should return the final score for a entry or nil
    # of he hasn't finished yet
    report_cards_score = report_cards.map(&:total_score)

    # remove nil values
    report_cards_score.select! { |n| !n.nil? }

    if report_cards_score.present?
      # we need to compute for the quantity of evaluated report cards
      report_cards_score.reduce(:+) * 1.0 / report_cards_score.count
    else
      0.0
    end
  end

  def next
    challenge.entries.where(is_valid: true).where('id > ?', id).order('id ASC').first
  end

  def prev
    challenge.entries.where('id < ?', id).order('id ASC').last
  end

  def limit_3_winner_entries
    if challenge.current_winners.count > 3
      raise 'En un reto solamente se pueden seleccionar hasta 3 ganadores'
    end
  end

  def invalid_entry?
    !is_valid
  end

  def valid_entry?
    is_valid
  end

  def mark_as_valid!
    self.is_valid = true
    self.invalid_reason = nil
    save!
  end

  def mark_as_invalid!(message)
    # we need a reason for this invalid_reason to be blank
    return false if message.blank?
    # destroy all report cards that belong to this entry
    # 'cause it has now been marked as invalid
    self.is_valid = false
    self.invalid_reason = message
    save!
    report_cards.destroy_all
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

  def member_email
    member.email
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

  def winner?
    winner == 1
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

  def initialize_report_cards
    challenge.evaluations.each { |e| e.verify_and_create_report_card_from(self) }
  end

  def validate_technologies!
    self.technologies = technologies.select do |technology|
      technology.present? && technologies_options.values.flatten.include?(technology)
    end
  end

  def idea_url_has_to_be_a_valid_url
    uri = URI(idea_url)
    uri = URI("http://#{uri}") if uri.scheme.nil?
    response = Net::HTTP.get_response(uri)
    response.is_a?(Net::HTTPSuccess)
    self.idea_url = response.uri.to_s
    errors.add(:idea_url, :invalid) unless uri.host.present?
  rescue URI::InvalidURIError
    errors.add(:idea_url, :invalid)
  rescue SocketError
    errors.add(:idea_url, :invalid)
  end
end
