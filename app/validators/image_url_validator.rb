class ImageUrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    valid = value =~ /^((http|https):\/\/)?(www\.)?.+\..+\/.+\.(gif|png|jpg)\/?$/i
    unless valid
      record.errors[attribute] << (options[:message] || "is an invalid image URL")
    end
  end

end