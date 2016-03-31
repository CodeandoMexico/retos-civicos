# GithubUrlValidator object determines if a value is a
# valid Github URL
class GithubUrlValidator < ActiveModel::EachValidator
  include BrigadesHelper
  def validate_each(record, attribute, value)
    pattern = %r{^((http|https):\/\/)?(www\.)?github\.com\/.+\/?$}
    error = 'is an invalid Github URL'
    validate_url(record, attribute, value, pattern, error)
  end
end