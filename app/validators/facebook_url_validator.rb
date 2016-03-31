# FacebookUrlValidator object determines if a value is a
# valid Facebook URL
class FacebookUrlValidator < ActiveModel::EachValidator
  include BrigadesHelper
  def validate_each(record, attribute, value)
    pattern = %r{^((http|https):\/\/)?(www\.)?facebook\.com\/.+\/?$}
    error = 'is an invalid Facebook URL'
    validate_url(record, attribute, value, pattern, error)
  end
end