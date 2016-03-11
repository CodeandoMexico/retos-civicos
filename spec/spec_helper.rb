# This file is copied to spec/ when you run 'rails generate rspec:install'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'devise'

# Set port to 3000
Capybara.server_port = "3000"

# Allow for proper login
include Warden::Test::Helpers
Warden.test_mode!
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:twitter] = {}
OmniAuth.config.mock_auth[:facebook] = {}

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Turn off delayed job in test
Delayed::Worker.delay_jobs = !Rails.env.test?

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.use_transactional_fixtures = false
  config.include Devise::TestHelpers, :type => :controller

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include SessionHelpers, type: :feature
  config.include UserHelpers
  config.include MailerHelpers
  # Model helpers
  config.include EntriesHelpers
  config.include EvaluationHelpers
  config.include FactoryGirl::Syntax::Methods

  # Database cleaner setup
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
  include Warden::Test::Helpers
end