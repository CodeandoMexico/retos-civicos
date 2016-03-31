class FacebookUrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    valid = value =~ /^((http|https):\/\/)?(www\.)?facebook\.com\/.+\/?$/i
    unless valid
      record.errors[attribute] << (options[:message] || "is an invalid Facebook URL")
    end
  end

end