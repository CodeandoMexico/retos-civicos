class EntryImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fill: [1000, 1000]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path('codeandomx.png')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :small do
    process resize_to_fill: [80, 80]
  end
end
