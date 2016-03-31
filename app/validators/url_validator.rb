class UrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    puts value.blank?
    puts "BING"
    return if value.blank?
    valid = begin
      URI.parse(value).kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
    unless valid
      record.errors[attribute] << (options[:message] || "is an invalid URL")
    end
  end

end