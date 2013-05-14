class User < ActiveRecord::Base

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

  # Additionals
  acts_as_voter

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

  def admin?
    role == 'admin'
  end

  def member?
    role == 'member'
  end

  def organization?
    role == 'org'
  end

  def collaborating_in?(challenge)
    Collaboration.where(user_id: self.id, challenge_id: challenge.id).blank? ? false : true
  end

  def update_skills(skills = [])
    self.skills = (self.skills + skills).uniq
  end

  def avatar_url
    if self.authentications.pluck(:provider).include? "twitter"
      twitter_auth = self.authentications.where(provider: 'twitter').first
      "http://api.twitter.com/1/users/profile_image?id=#{twitter_auth.uid}&size=bigger"
    elsif self.avatar
      self.avatar
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
      linkedin_auth.public_url.present? ? linkedin_auth.public_url : ''
    end
  end

  def create_role(params = {})
    if params[:organization].present?
      self.userable = Organization.new
    else
      self.userable = Member.new
    end
    self.save
  end    
end
