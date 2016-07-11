# SlackUrlValidator object determines if a value is a
# valid Slack URL
class SlackUrlValidator < ActiveModel::EachValidator
  include BrigadesHelper
  def validate_each(record, attribute, value)
    pattern = %r{^((http|https):\/\/)?(www\.)?.{0,21}\.slack\.com\/?.{0,21}\/?$}
    error = 'is an invalid Slack URL'
    validate_url(record, attribute, value, pattern, error)
  end
end
