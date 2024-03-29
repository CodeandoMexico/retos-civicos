class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.find_for_provider_oauth(omniauth, signed_in_resource = nil)
    case omniauth.provider
    when 'github', 'linkedin', 'facebook'
      find_or_create_with_omniauth(omniauth, signed_in_resource)
    when 'twitter'
      find_for_twitter_oauth(omniauth, signed_in_resource)
    else
      raise 'Provider not Found'
    end
  end

  def self.find_or_create_with_omniauth(omniauth, current_user)
    auth = where(provider: omniauth.provider, uid: omniauth.uid).first
    return auth if auth.present?

    user = current_user || User.find_or_build_with_omniauth(omniauth.info)
    create_with_omniauth(omniauth, user)
  end

  def self.create_with_omniauth(omniauth, user)
    auth = user.authentications.build(
      provider: omniauth.provider,
      uid: omniauth.uid,
      public_url: omniauth.info.urls[public_url_key(omniauth.provider)])

    user.remote_avatar_url = omniauth.info.image
    user.save
    auth
  end

  def self.public_url_key(provider)
    {
      'github' => 'Github',
      'linkedin' => 'public_profile',
      'facebook' => 'Facebook'
    }.fetch(provider)
  end

  def self.create_with_twitter(omniauth, user)
    auth = user.authentications.build(provider: omniauth.provider, uid: omniauth.uid)
    user.save validate: false
    TwitterApi.new(user.id).save_profile_image
    auth
  end

  def self.find_for_twitter_oauth(omniauth, signed_in_resource = nil)
    auth = where(provider: omniauth.provider, uid: omniauth.uid).first
    unless auth.present?
      if signed_in_resource
        # If there's a user signed in it builds a new authentication
        auth = create_with_twitter(omniauth, signed_in_resource)
      else
        user = User.new(name: omniauth.info.name, nickname: omniauth.info.nickname)
        # Devise confirm user and skip email
        user.skip_confirmation!
        # It creates a Member role for the user
        user.userable = Member.new
        # It creates a user with twitter
        auth = create_with_twitter(omniauth, user)
      end
    end
    auth
  end
end
