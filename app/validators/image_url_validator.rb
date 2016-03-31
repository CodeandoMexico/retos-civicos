# ImageUrlValidator object determines if a value is a
# valid image URL
class ImageUrlValidator < ActiveModel::EachValidator
  include BrigadesHelper
  def validate_each(record, attribute, value)
    pattern = %r{^((http|https):\/\/)?(www\.)?.+\..+\/.+\.(gif|png|jpg)\/?$}
    error = 'is an invalid image URL'
    validate_url(record, attribute, value, pattern, error)
  end
end