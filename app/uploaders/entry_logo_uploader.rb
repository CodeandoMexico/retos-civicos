# encoding: utf-8

class EntryLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fill => [80,80]

  def store_dir
    "uploads/entries_logo/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path('codeandomexico80.png')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
