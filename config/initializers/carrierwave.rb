CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AMAZON_ACCESS_KEY'],
    aws_secret_access_key: ENV['AMAZON_SECRET_KEY']
  }
  config.fog_directory  = ENV['AMAZON_S3_BUCKET']
  config.fog_public     = true

  config.permissions = 0600

  config.storage(Rails.env.test? || Rails.env.development? ? :file : :fog)
end
