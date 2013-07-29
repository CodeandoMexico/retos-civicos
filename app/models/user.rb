class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :validatable
  devise :omniauthable, omniauth_providers: [:github, :twitter, :linkedin]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = ["member", "organization"]

  attr_accessible :avatar, :email, :name, :nickname, :bio, :userable_id, :role

  # Relations
  has_many :authentications, dependent: :destroy

  has_many :created_challenges, foreign_key: "creator_id", class_name: "Challenge"
  has_many :collaborations, foreign_key: 'user_id', dependent: :destroy
  has_many :collaborating_in, through: :collaborations, class_name: "Challenge", source: :challenge
  has_many :userskills
  has_many :skills, through: :userskills
  has_many :comments

  belongs_to :userable, polymorphic: true

  # Validations
  validates :bio, length: { maximum: 255 }
  validates_format_of :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/, on: :update

  scope :from_twitter, lambda { joins(:authentications).where("authentications.provider = ?", "twitter") }

  # Additionals
  acts_as_voter
  mount_uploader :avatar, UserAvatarUploader

  after_create :fetch_twitter_avatar, if: :has_twitter_auth?

  after_create do
    self.create_role if self.userable.nil?
  end

  def self.create_with_omniauth(auth)
    user = User.new(name: auth["info"]["name"], nickname: auth["info"]["nickname"], email: auth["info"]["email"])
    user.avatar = auth.info.image if auth.provider == "linkedin"
    authentication = user.authentications.build(provider: auth['provider'], uid: auth['uid']) 
    authentication.user = user
    authentication.apply_extra_info_from_omniauth(auth)
    user.save
    user
  end

  def to_s
    name.blank? ? (nickname.blank? ? email : nickname) : name
  end

  #Ex: member?, organization?
  ROLES.each do |role|
    define_method "#{role}?" do
      userable_type == role.capitalize
    end
  end

  def has_role?
    not self.userable_type.blank?
  end

  def has_twitter_auth?
    not self.authentications.where(provider: 'twitter').blank?
  end

  def collaborating_in?(challenge)
    self.userable.challenge_ids.include?(challenge.id) unless self.userable_id.nil?
  end

  def update_skills(skills = [])
    self.skills = (self.skills + skills).uniq
  end

  def image_url(version = nil)
    self.avatar_url(version) or Gravatar.new(self.email.to_s).image_url
  end

  def profile_url
    if self.authentications.map(&:provider).include? "twitter" 
      "http://twitter.com/#{self.nickname}"
    elsif self.authentications.map(&:provider).include? "github"
      "http://github.com/#{self.nickname}"
    else
      linkedin_public_url = self.authentications.map { |auth| auth.public_url }.first
      # TODO: Refactor this to presenters
      linkedin_public_url.blank? ? 'javascript:void(0)' : linkedin_public_url # Sorry @bhserna
    end
  end

  def create_role(params = {})
    if params[:organization].present?
      self.userable = Organization.new
    else
      self.userable = Member.new
    end
    # To-do: Temporary removed validation. Remove validate false after major refactor.
    self.save validate: false
  end    

  def just_created?
    self.created_at == self.updated_at 
  end

  def confirmation_required?
    if self.has_twitter_auth? then !confirmed? else confirmed? end
  end

  private

  def fetch_twitter_avatar
    TwitterAvatarFetcher.new(self.id).delay.fetch
  end
end
