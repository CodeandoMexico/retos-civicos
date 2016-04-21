task send_to_codeclimate: :environment do
  require 'simplecov'
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)
end
