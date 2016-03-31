class TwitterUrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    valid = value =~ /^((http|https):\/\/)?(www\.)?twitter\.com\/.+\/?$/i
    unless valid
      record.errors[attribute] << (options[:message] || "is an invalid Twitter URL")
    end
  end

end