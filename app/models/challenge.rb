#encoding: utf-8
class Challenge < ActiveRecord::Base

  attr_accessible :dataset_id, :dataset_url, :description, :owner_id, :status, :title, :additional_links,
                  :welcome_mail, :subject, :body, :first_spec, :second_spec, :third_spec, :fourth_spec, :fifth_spec,
                  :pitch, :avatar, :about, :activities_attributes, :dataset_file, :entry_template_url,
                  :infographic, :prize

  attr_accessible(*Phases.dates)

  attr_accessor :dataset_file

  store :welcome_mail, accessors: [:subject, :body]

  mount_uploader :avatar, ChallengeAvatarUploader
  mount_uploader :infographic, ChallengeInfographicUploader

  paginates_per 12

  # Relations
  has_many :collaborations
  has_many :collaborators, through: :collaborations, class_name: "Member", source: :member, include: :user
  has_many :activities
  has_many :entries

  belongs_to :organization
  # Validations
  validates :description, :title, :status, :about, :pitch, presence: true
  validates(*Phases.dates, presence: true)
  validates :pitch, length: { maximum: 140 }

  accepts_nested_attributes_for :activities, :reject_if => lambda { |a| a[:text].blank? }

  after_create :create_initial_activity

  #Scopes
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

  def to_param
    "#{id}-#{title}".parameterize
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

  def has_finished?
    Date.current > finish_on
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
    if self.dataset_id
      self.dataset_id.split(',')
    else
      []
    end
  end

  def dataset_info(d)
    response = CKAN::Action::action_get("package_show", { "id" => d } )
    response['result']
  end

  def prepopulate_dataset_id
    if self.dataset_id
      datos = {}
      datos_json = ""
      c = 0
      self.datasets_id.each do |d|
        c += 1
        response = CKAN::Action::action_get("package_show", { "id" => d } )
        datos['id'] = d
        datos['title'] = response['result']['title']
        datos_json += datos.to_json
        datos_json += "," unless c == self.datasets_id.count
      end
      datos_json.html_safe
    else
      ""
    end
  end

  def has_a_winner?
    Entry.where(challenge_id:self, winner:1).count > 0
  end

  def has_finalists?
    Entry.where(challenge_id:self, accepted:true).count > 0
  end

  def current_winner
    Entry.where(challenge_id:self, winner:1).first if self.has_a_winner?
  end

  def current_finalists
    Entry.where(challenge_id:self, accepted: true).select { |e| e != self.current_winner }
  end

  def current_phase_title
    Phases.current_phase_title(self)
  end

  def self.has_only_one_challenge?
    # self.count == 1
    where("status = 'open' OR status = 'working_on'").count == 1
  end

  def is_public?
    self.status == 'open' || self.status == 'working_on'
  end

  private

  def create_initial_activity
    self.activities.create(title: I18n.t("challenges.initial_activity.title"), text: I18n.t("challenges.initial_activity.text"))
  end
end
