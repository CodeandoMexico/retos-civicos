require 'simplecov'
require "codeclimate-test-reporter"
SimpleCov.add_filter 'vendor'
SimpleCov.add_filter 'lib/tasks'
SimpleCov.use_merging true
SimpleCov.start