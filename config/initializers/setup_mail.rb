ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SMTP_SETTINGS_USERNAME'],
  :password => ENV['SMTP_SETTINGS_PASSWORD'],
  :domain => ENV['SMTP_SETTINGS_DOMAIN'],
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
