# UrlValidator object determines if a value is a
# valid URL
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    valid = begin
      URI.parse(value).is_a?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
    record.errors[attribute] << (options[:message] || 'is an invalid URL') unless valid
  end
end