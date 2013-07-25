Rails.application.config.middleware.use OmniAuth::Builder do

  linkedin_fields = ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "skills"]

  provider :github, GITHUB_KEY, GITHUB_SECRET
  provider :linkedin, LINKEDIN_KEY, LINKEDIN_SECRET, scope: 'r_fullprofile r_emailaddress', fields: linkedin_fields
  provider :twitter, TWITTER_KEY, TWITTER_SECRET

end

OmniAuth.config.on_failure = AuthenticationsController.action(:failure)
