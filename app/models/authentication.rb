class Authentication < ActiveRecord::Base

  attr_accessible :provider, :uid, :user_id, :public_url

  belongs_to :user

  def self.find_for_provider_oauth(omniauth, signed_in_resource = nil)
    send("find_for_#{omniauth.provider}_oauth", omniauth, signed_in_resource) 
  end

  def self.find_for_github_oauth(omniauth, signed_in_resource = nil)
    auth = self.where(provider: omniauth.provider, uid: omniauth.uid).first
    unless auth.present?
      if signed_in_resource
        # If there's a user signed in it builds a new authentication
        auth = self.create_with_github(omniauth, signed_in_resource)
      else
        # If there's no signed in user we look for a user with the email
        user = User.where(email: omniauth.info.email).first
        if not user.present?
          # If there's no user with that email with create it with its new auth
          user = User.new(name: omniauth.info.name,
                          nickname: omniauth.info.nickname,
                          email: omniauth.info.email,
                          password: Devise.friendly_token[0,20])
          # Devise confirm user and skip email
          user.skip_confirmation!
          # It creates a Member role for the user and saves it
          user.userable = Member.new
        end
        auth = self.create_with_github(omniauth, user)
      end
    end
    auth
  end

  def self.find_for_linkedin_oauth(omniauth, signed_in_resource = nil)
    auth = self.where(provider: omniauth.provider, uid: omniauth.uid).first
    unless auth.present?
      if signed_in_resource
        # If there's a user signed in it builds a new authentication
        auth = self.create_with_linkedin(omniauth, signed_in_resource)
      else
        # If there's no signed in user we look for a user with the email
        user = User.where(email: omniauth.info.email).first
        if not user.present?
          # If there's no user with that email with create it with its new auth
          user = User.new(name: omniauth.info.name,
                          nickname: omniauth.info.nickname,
                          email: omniauth.info.email,
                          password: Devise.friendly_token[0,20])
          # Devise confirm user and skip email
          user.skip_confirmation!
          # It creates a Member role for the user and saves it
          user.userable = Member.new
        end
        auth = self.create_with_linkedin(omniauth, user)
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
    TwitterAvatarFetcher.new(user.id).fetch
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
