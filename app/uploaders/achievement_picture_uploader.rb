# encoding: utf-8
class AchievementPictureUploader < CarrierWave::Uploader::Base

  storage :file
  include CarrierWave::RMagick

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  def store_dir
    "system/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [100, 100]
  end

  version :large do
    process resize_to_fill: [300, 300]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
