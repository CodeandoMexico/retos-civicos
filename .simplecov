require 'codeclimate-test-reporter'
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                         SimpleCov::Formatter::HTMLFormatter,
                                                         CodeClimate::TestReporter::Formatter
                                                     ])
end