source 'https://rubygems.org'

ruby '2.1.3'

gem 'rails', '3.2.19'

gem 'foreman'
gem 'pg'

# Heroku compability
gem 'rails_12factor', group: [:staging, :production]

# OAuth providers
gem 'omniauth-github'
gem 'omniauth-linkedin'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

gem 'devise', '~> 3.0.0'
gem 'cancan'
gem 'github_api'
gem 'gravatar-ultimate'

gem 'rails-translate-routes'
gem 'ckan', github: 'CodeandoMexico/CKAN-rb'

group :test do
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'database_cleaner'
end
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'zurb-foundation',  '~> 3.2.0'
  gem 'uglifier', '>= 1.0.3'
  gem 'timelineJS-rails', '~> 1.1.1'
  gem 'bootstrap-sass', '~> 3.1.1'
  gem 'font-awesome-sass'
end

group :development do
  gem 'thin'
  gem 'debugger2'
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'unicorn'
end

gem 'kaminari'
gem 'compass'
gem 'fog'
gem 'carrierwave', '~> 0.8.0'
gem 'mini_magick'
gem 'sanitize'
gem 'auto_html'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-tokeninput-rails', github: 'acrogenesis/jquery-tokeninput-rails'
gem 'thumbs_up'
gem 'acts_as_commentable_with_threading'
gem 'dynamic_form'
gem 'twitter', '~> 5.8.0'
gem 'sendgrid'
gem 'delayed_job_active_record'
gem 'redcarpet'
gem 'figaro'
gem 'onebox', '~> 1.2'
gem 'validate_url'
gem 'rack-utf8_sanitizer'

# Console tools
gem 'ruby-progressbar'
gem 'newrelic_rpm'
gem 'airbrake'
gem 'hirb'

# Rack tools
gem 'rack-no-www'

# Cache tools
gem 'rack-cache'
gem 'dalli'
gem 'kgio'
gem "memcachier"
