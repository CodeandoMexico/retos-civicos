class SlackUrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    valid = value =~ /^((http|https):\/\/)?(www\.)?.{0,21}\.slack\.com\/?.{0,21}\/?$/i
    unless valid
      record.errors[attribute] << (options[:message] || "is an invalid Slack URL")
    end
  end

end