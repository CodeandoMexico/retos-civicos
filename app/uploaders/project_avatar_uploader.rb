# encoding: utf-8

class ProjectAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :profile do
    process :resize_to_fit => [600, 360]
  end

  version :small do
    process :resize_to_fit => [300, 180]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/project_avatar/#{model.id}"
  end

  def default_url
    "/assets/project_avatar_#{version_name}.png"
  end
end
