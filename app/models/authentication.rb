class Authentication < ActiveRecord::Base

  attr_accessible :provider, :uid, :user_id, :public_url

  belongs_to :user

  def self.find_for_provider_oauth(omniauth, signed_in_resource = nil)
    case omniauth.provider
    when 'github', 'linkedin'
      find_or_create_with_omniauth(omniauth, signed_in_resource)
    when 'twitter'
      find_for_twitter_oauth(omniauth, signed_in_resource)
    end
  end

  # Method to build an Authentication for GitHub and LinkedIn
  def self.find_or_create_with_omniauth(omniauth, current_user)
    auth = self.where(provider: omniauth.provider, uid: omniauth.uid).first
    unless auth.present?
      if current_user
        # If there's a user signed in it builds a new authentication
        auth = send("create_with_#{omniauth.provider}", omniauth, current_user)
      else
        # If there's no signed in user we look for a user with the email
        user = User.find_or_build_with_omniauth(omniauth.info)
        auth = send("create_with_#{omniauth.provider}", omniauth, user)
      end
    end
    auth
  end

  def self.create_with_github(omniauth, user)
    auth = user.authentications.build(provider: omniauth.provider, uid: omniauth.uid, public_url: omniauth.info.urls.GitHub)
    user.remote_avatar_url = omniauth.info.image
    user.save
    auth
  end

  def self.create_with_linkedin(omniauth, user)
    auth = user.authentications.build(provider: omniauth.provider, uid: omniauth.uid, public_url: omniauth.info.urls.public_profile)
    user.remote_avatar_url = omniauth.info.image
    user.save
    auth
  end

  def self.create_with_twitter(omniauth, user)
    auth = user.authentications.build(provider: omniauth.provider, uid: omniauth.uid)
    user.save validate: false
    TwitterApi.new(user.id).save_profile_image
    auth
  end

  def self.find_for_twitter_oauth(omniauth, signed_in_resource = nil)
    auth = self.where(provider: omniauth.provider, uid: omniauth.uid).first
    unless auth.present?
      if signed_in_resource
        # If there's a user signed in it builds a new authentication
        auth = self.create_with_twitter(omniauth, user)
      else
        user = User.new(name: omniauth.info.name, nickname: omniauth.info.nickname)
        # Devise confirm user and skip email
        user.skip_confirmation!
        # It creates a Member role for the user
        user.userable = Member.new
        # It creates a user with twitter
        auth = self.create_with_twitter(omniauth, user)
      end
    end
    auth
  end

end
