# TwitterUrlValidator object determines if a value is a
# valid Twitter URL
class TwitterUrlValidator < ActiveModel::EachValidator
  include BrigadesHelper
  def validate_each(record, attribute, value)
    pattern = %r{^((http|https):\/\/)?(www\.)?twitter\.com\/.+\/?$}
    error = 'is an invalid Twitter URL'
    validate_url(record, attribute, value, pattern, error)
  end
end
