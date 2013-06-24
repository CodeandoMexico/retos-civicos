class User < ActiveRecord::Base

  ROLES = ["member", "organization"]

  attr_accessible :avatar, :email, :name, :nickname, :bio, :userable_id, :role

  # Relations
  has_many :authentications, dependent: :destroy

  has_many :created_challenges, foreign_key: "creator_id", class_name: "Challenge"
  has_many :collaborations, foreign_key: 'user_id'
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
    name || nickname || email
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

  def collaborating_in?(challenge)
    self.userable.challenges.include?(challenge)
  end

  def update_skills(skills = [])
    self.skills = (self.skills + skills).uniq
  end

  def avatar_image_url
    if self.authentications.pluck(:provider).include? "twitter"
      twitter_auth = self.authentications.where(provider: 'twitter').first
      begin
        Twitter.user(self.nickname).profile_image_url.sub("_normal", "")
      rescue 
        Gravatar.new("generic@example.com").image_url
      end
    else
      Gravatar.new(self.email.to_s).image_url
    end
  end

  def profile_url
    if self.authentications.pluck(:provider).include? "twitter" 
      "http://twitter.com/#{self.nickname}"
    elsif self.authentications.pluck(:provider).include? "github"
      "http://github.com/#{self.nickname}"
    else
      linkedin_auth= self.authentications.where(provider: 'linkedin').first
      # TODO: Refactor this to presenters
      linkedin_auth.public_url.present? ? linkedin_auth.public_url : 'javascript:void(0)' # Sorry @bhserna
    end
  end

  def create_role(params = {})
    user_role = nil
    if params[:organization].present?
      self.userable = Organization.new
      user_role =  self.userable
    else
      self.userable = Member.new
      user_role = self.userable
    end
    # To-do: Temporary removed validation. Remove validate false after major refactor.
    user_role.save validate: false
  end    

  def just_created?
    self.created_at == self.updated_at 
  end
end
