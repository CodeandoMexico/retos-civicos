ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SMTP_CONFIG_USERNAME'],
  :password => ENV['SMTP_CONFIG_PASSWORD'],
  :domain => ENV['SMTP_CONFIG_DOMAIN'],
  :address => ENV['SMTP_CONFIG_ADDRESS'],
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
