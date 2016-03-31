class GithubUrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    valid = value =~ /^((http|https):\/\/)?(www\.)?github\.com\/.+\/?$/i
    unless valid
      record.errors[attribute] << (options[:message] || "is an invalid Github URL")
    end
  end

end