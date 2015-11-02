# encoding: utf-8
class Challenge < ActiveRecord::Base
  attr_accessible :dataset_id, :dataset_url, :description, :owner_id, :status, :title, :additional_links,
                  :welcome_mail, :subject, :body, :first_spec, :second_spec, :third_spec, :fourth_spec, :fifth_spec,
                  :pitch, :avatar, :about, :activities_attributes, :dataset_file, :entry_template_url,
                  :infographic, :prize, :assessment_methodology, :evaluation_criteria,
                  :evaluation_instructions, :evaluations_opened

  attr_accessible(*Phases.dates)

  attr_accessor :dataset_file

  store :welcome_mail, accessors: [:subject, :body]
  serialize :evaluation_criteria, Array

  mount_uploader :avatar, ChallengeAvatarUploader
  mount_uploader :infographic, ChallengeInfographicUploader

  paginates_per 12

  # Relations
  has_many :collaborations
  has_many :collaborators, through: :collaborations, class_name: "Member", source: :member, include: :user
  has_many :activities
  has_many :entries, order: 'id ASC'
  has_many :datasets
  has_many :evaluations, order: 'id ASC'
  has_many :judges, through: :evaluations

  belongs_to :organization
  # Validations
  validates :description, :title, :status, :about, :pitch, presence: true
  validates(*Phases.dates, presence: true)
  validates :pitch, length: { maximum: 140 }
  validate :criteria_must_be_valid, on: :update, if: :criteria_must_be_present

  accepts_nested_attributes_for :activities, :reject_if => lambda { |a| a[:text].blank? }

  after_create :create_initial_activity, :create_or_update_datasets
  after_update :create_or_update_datasets, :update_report_cards

  #Scopes
  scope :sorted, lambda { order('created_at DESC') }

  scope :active, lambda {
    where("status = 'open' OR status = 'working_on'")
  }

  scope :inactive, lambda {
    where("status = 'finished' OR status = 'cancelled'")
  }

  scope :private, lambda {
    where("status = 'private'")
  }

  scope :recent, lambda {
    where(['starts_on <= ?', Date.current]).order('created_at DESC')
  }

  scope :popular, lambda {
    joins('LEFT OUTER JOIN collaborations ON collaborations.challenge_id = challenges.id').
    select('challenges.*, count(collaborations.challenge_id) as "challenge_count"').
    group('challenges.id').
    order('challenge_count desc')
  }

  def self.last_created
    Challenge.order('created_at desc').first
  end

  def self.missing_winner_challenges(args)
    challenges = Challenge.where(organization_id: args[:organization]).where('finish_on <= ?', Date.current)
    challenges.reject { |c| c if c.has_a_winner? }
  end

  # Additionals
  acts_as_voteable
  acts_as_commentable

  # Embeddables
  auto_html_for :description do
    simple_format
    image
    youtube width: 400, height: 250, wmode: "transparent"
    vimeo   width: 400, height: 250
    link target: "_blank", rel: "nofollow"
  end

  STATUS = [:private, :open, :working_on, :cancelled, :finished]

  def export_evaluations(opts={})
    CSV.generate(opts) do |csv|
      criteria_field_names = self.evaluation_criteria.map { |criteria| criteria[:description] }
      # name of the csv column fields
      csv << ['Juez', 'Equipo'] + criteria_field_names + ['Comentarios']
      self.evaluations.each do |e|
        e.report_cards.each do |r|
          # let's fetch the grades first
          grades = r.grades.map { |criteria| criteria[:value] }
          # output to the csv
          csv << [r.evaluation.judge.name, r.entry.name] + grades + [r.comments]
        end
      end
    end
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

  def close_evaluation
    self.evaluations_opened = false
    self.save
  end

  def ranked_entries
    self.entries.where(winner: 1) +
    self.entries.where(accepted: true).where(winner: nil) +
    self.entries.where(accepted: false)
  end

  def sort_entries_by_scores
    self.entries.where(is_valid: true).sort! { |a, b| b.final_score <=> a.final_score }
  end

  def ready_to_rank_entries?
    self.has_valid_criteria? && self.has_evaluations?
  end

  def finished_evaluating?
    self.evaluations.each do |evaluation|
      return false if evaluation.status < 2
    end
    true
  end

  def has_valid_criteria?
    self.criteria_must_be_present && self.criteria_must_be_valid.nil?
  end

  def has_evaluations?
    self.evaluations.present?
  end

  def criteria_must_be_present
    self.evaluation_criteria.present?
  end

  def criteria_must_be_valid
    ponderation_counter = 0
    self.evaluation_criteria.each do |criteria|
      if criteria[:description].blank? || !criteria[:value].is_number?
        return errors.add(:evaluation_criteria, 'Los criterios no están correctamente definidos')
      else
        ponderation_counter = ponderation_counter + criteria[:value].to_f
      end
    end
    return errors.add(:evaluation_criteria, 'La suma de las ponderaciones debe ser 100.') if ponderation_counter != 100
  end

  def cancel!
    self.status = :cancelled
    self.save
  end

  def update_likes_counter
    self.likes_counter = self.votes_count
    self.save
  end

  def total_references
    self.references.size
  end

  def references
    (self.additional_links || '').split(",")
  end

  def about
    self[:about].to_s
  end

  def is_active?
    starts_on <= Date.current && Date.current <= finish_on
  end

  def has_started?
    Date.current >= starts_on
  end

  def has_finished?
    Date.current >= finish_on
  end

  def specs?
    self.first_spec.present? ||
    self.second_spec.present? ||
    self.third_spec.present? ||
    self.fourth_spec.present? ||
    self.fifth_spec.present?
  end

  def timeline_json
    {
      "timeline" =>
      {
        "headline" => "Actividades y Noticias",
        "type" => "default",
        "startDate" => self.created_at.year,
        "text" => "",
        "date" => self.activities.map do |activity|
          date = activity.created_at.strftime("%Y, %m, %d")
          {
            "startDate" => date,
            "endDate" => date,
            "headline" => activity.title,
            "text" => activity.text,
            "asset" =>
            {
              "media" => "",
              "credit" => "",
              "caption" => ""
            }
          }

        end
      }
    }
  end

  def datasets_id
    if dataset_id
      dataset_id.split(',')
    else
      []
    end
  end

  def prepopulate_dataset_id
    data = []
    if datasets
      datasets.each do |d|
        data << d.tokenizer_hash
      end
      data.to_json.tr('[]', '').html_safe
    else
      ''
    end
  end

  def has_a_winner?
    Entry.where(challenge_id: self, winner: 1).count > 0
  end

  def has_participants?
    Entry.where(challenge_id: self).count > 0
  end

  def has_finalists?
    Entry.where(challenge_id: self, accepted: true).count > 0
  end

  def current_winners
    if self.has_a_winner?
      Entry.where(challenge_id: self, winner: 1)
    else
      []
    end
  end

  def current_participants
    Entry.where(challenge_id: self)
  end

  def current_finalists
    Entry.includes(:member).where(challenge_id: self, accepted: true) - current_winners
  end

  def current_phase_title(args = {})
    if has_finished?
      phase = I18n.t('challenges.show.has_finished')
    else
      phase = Phases.current_phase_title(self).title(args)
    end
    phase
  end

  def self.has_only_one_challenge?
    # self.count == 1
    where("status = 'open' OR status = 'working_on'").count == 1
  end

  def public?
    self.status == 'open' || self.status == 'working_on' || self.status == 'finished'
  end

  private

  def update_report_cards
    self.evaluations.each do |e|
      e.report_cards.each { |r| r.update_criteria_description(self.evaluation_criteria) }
    end
  end

  def create_or_update_datasets
    datasets_id.each do |d|
      response = CKAN::Action.action_get('package_show', 'id' => d)
      result = response['result']
      dataset = Dataset.find_or_initialize_by_guid(d)
      dataset.update_attributes(guid: d, title: result['title'], name: result['name'],
                     format: result['resources'][0]['format'], notes: result['notes'], challenge_id: id)
      remove_datasets
    end
  end

  def remove_datasets
    to_remove = datasets - datasets.find_all_by_guid(datasets_id)
    to_remove.each do |remove|
      Dataset.delete(remove)
    end
  end

  def create_initial_activity
    self.activities.create(title: I18n.t("challenges.initial_activity.title"), text: I18n.t("challenges.initial_activity.text"))
  end
end
