# This hook is use to setup the configuration for creating models through
# rails generators
Ninsho.setup do |config|
  
  # ==> ORM Configuration
  # Load and configure the ORM. Supports :active_record
  require 'ninsho/orm/active_record'

  #Omniauth Providers
  config.omniauth :github, GITHUB_KEY, GITHUB_SECRET
  config.omniauth :linkedin, LINKEDIN_KEY, LINKEDIN_SECRET, scope: 'r_fullprofile r_emailaddress', fields: ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "skills"]
  config.omniauth :twitter, TWITTER_KEY, TWITTER_SECRET
end
