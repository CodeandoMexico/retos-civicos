# A User is representative of a person who can join brigades,
# participate in challenges, create brigades, etc. Can also be
# administrators, organizations, or judges.
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :twitter]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :avatar, :email, :name,
                  :nickname, :bio, :userable_id, :role, :website, :show_profile

  ROLES = %w(member organization judge).freeze

  attr_accessible

  # Relations
  has_many :authentications, dependent: :destroy

  has_many :created_challenges, foreign_key: 'creator_id', class_name: 'Challenge'
  has_many :collaborations, foreign_key: 'user_id', dependent: :destroy
  has_many :collaborating_in, through: :collaborations, class_name: 'Challenge', source: :challenge
  has_many :userskills
  has_many :skills, through: :userskills
  has_many :comments
  has_many :brigade_users
  has_many :brigades, through: :brigade_users, include: :location
  has_many :brigade_projects_users
  has_many :brigade_projects, through: :brigade_projects_users_users

  belongs_to :userable, polymorphic: true

  # Validations
  validates :bio, length: { maximum: 255 }
  validates_format_of :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/, on: :update

  scope :from_twitter, -> { joins(:authentications).where('authentications.provider = ?', 'twitter') }

  # Additionals
  acts_as_voter
  mount_uploader :avatar, UserAvatarUploader

  after_create :fetch_twitter_avatar, if: :twitter_auth?

  after_create do
    create_role if userable.nil?
  end

  def self.find_or_build_with_omniauth(info)
    user = User.where(email: info.email).first
    return user if user.present?

    # If there's no user with that email we create it with its new auth

    user = User.new(name: info.name,
                    nickname: info.nickname,
                    email: info.email,
                    password: Devise.friendly_token[0, 20])
    # Devise confirm user and skip email
    user.skip_confirmation!
    # It creates a Member role for the user and saves it
    user.userable = Member.new
    user
  end

  def to_s
    return name unless name.blank?
    return nickname unless nickname.blank?
    email
  end

  def to_param
    return "#{id}-#{name.parameterize}" if name
    return "#{id}-#{nickname.parameterize}" if nickname
    id
  end

  # Ex: member?, organization?
  ROLES.each do |role|
    define_method "#{role}?" do
      userable_type == role.capitalize
    end
  end

  def member?
    userable_type == 'Member'
  end

  def organization?
    userable_type == 'Organization'
  end

  def judge?
    userable_type == 'Judge'
  end

  def twitter_auth?
    !authentications.where(provider: 'twitter').blank?
  end

  def github_auth?
    !authentications.where(provider: 'github').blank?
  end

  def linkedin_auth?
    !authentications.where(provider: 'linkedin').blank?
  end

  def collaborating_in?(challenge)
    userable.challenge_ids.include?(challenge.id) unless userable_id.nil?
  end

  def image_url(version = nil)
    avatar_url(version) || Gravatar.new(email.to_s).image_url
  end

  def profile_url
    if twitter_auth?
      "http://twitter.com/#{nickname}"
    elsif github_auth? || linkedin_auth?
      # LinkedIn or Github URL
      authentications.first.public_url
    else
      # No public URL.
      'javascript:void(0)'
    end
  end

  def create_role(params = {})
    self.userable = if params[:organization].present?
                      Organization.new
                    elsif params[:judge].present?
                      Judge.new
                    else
                      Member.new
                    end
    # To-do: Temporary removed validation. Remove validate false after major refactor.
    save validate: false
  end

  def just_created?
    created_at == updated_at
  end

  def self.admin_of_challenge?(challenge, current_organization)
    current_organization.present? && current_organization.id == challenge.organization.id
  end

  private

  def fetch_twitter_avatar
    TwitterApi.new(id).delay.save_profile_image
  end
end
