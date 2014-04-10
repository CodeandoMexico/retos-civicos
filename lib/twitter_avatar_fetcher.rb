class TwitterAvatarFetcher

  def initialize(user_id)
    @user_id = user_id
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.access_token = TWITTER_ACCESS_KEY
      config.access_token_secret = TWITTER_ACCESS_SECRET
    end
  end

  def user
    @user ||= User.find(@user_id)
  end

  def auth
    @auth ||= user.authentications.where(provider: 'twitter').first
  end

  def fetch
    image_url = @client.user(auth.uid.to_i).profile_image_url.to_s.sub("_normal", "")

    user.remote_avatar_url = image_url
    user.save validate: false
    nil
  end

end
