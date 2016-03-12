# encoding: utf-8

class ChallengeAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :profile do
    process resize_to_fit: [600, 360]
  end

  version :small do
    process resize_to_fit: [355, 180]
  end

  def default_url
    ActionController::Base.helpers.asset_path('ph-challenge-widget.png')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/project_avatar/#{model.id}"
  end
end
