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
    output_file = File.open("#{Rails.root}/tmp/#{user.id}.jpeg", "wb")
    open(image_url) do |f|
      output_file.puts f.read
    end

    user.avatar = output_file
    user.save validate: false
    File.delete(output_file)
    nil
  end

end
