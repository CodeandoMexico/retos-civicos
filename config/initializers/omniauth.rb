Rails.application.config.middleware.use OmniAuth::Builder do

  provider :github, GITHUB_KEY, GITHUB_SECRET
  provider :linkedin, LINKEDIN_KEY, LINKEDIN_SECRET
  provider :twitter, TWITTER_KEY, TWITTER_SECRET

end
