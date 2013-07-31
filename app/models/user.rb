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


  def self.find_or_build_with_omniauth(info)
    user = User.where(email: info.email).first
    if not user.present?
      # If there's no user with that email with create it with its new auth
      user = User.new(name: info.name,
                      nickname: info.nickname,
                      email: info.email,
                      password: Devise.friendly_token[0,20])
      # Devise confirm user and skip email
      user.skip_confirmation!
      # It creates a Member role for the user and saves it
      user.userable = Member.new
    end
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

  def has_github_auth?
    not self.authentications.where(provider: 'github').blank?
  end

  def has_linkedin_auth?
    not self.authentications.where(provider: 'linkedin').blank?
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
    if has_twitter_auth?
      "http://twitter.com/#{self.nickname}"
    elsif has_github_auth? or has_linkedin_auth?
      # LinkedIn or Github URL
      self.authentications.first.public_url
    else
      # No public URL.
      'javascript:void(0)'
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

  private

  def fetch_twitter_avatar
    TwitterAvatarFetcher.new(self.id).delay.fetch
  end
end
