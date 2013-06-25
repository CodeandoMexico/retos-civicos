class TwitterAvatarFetcher

  def initialize(user_id)
    @user_id = user_id
  end

  def user
    @user ||= User.find(@user_id)
  end

  def auth
    @auth ||= user.authentications.where(provider: 'twitter').first
  end

  def fetch
    image_url = Twitter.user(auth.uid.to_i).profile_image_url.sub("_normal", "")

    user.remote_avatar_url = image_url
    user.save validate: false
    nil
  end

end
