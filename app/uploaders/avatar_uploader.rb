# encoding: utf-8
# :nodoc:
class AvatarUploader < BaseImageUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.asset_path('users/' +
      [version_name, 'avatar.gif'].compact.join('_'))
  end

  process store_meta: [{ md5sum: true }]

  # Process files as they are uploaded:
  version :source do
    resize_to_limit(500, 500)
    process :store_meta

    # This is the cropped version of parent image. Let crop to 50x50 square.
    version :preview do
      process crop_to: [160, 160]
      process :store_meta
    end

    version :thumb do
      process crop_to: [120, 120]
      process :store_meta
    end

    version :icon do
      process crop_to: [50, 50]
      process :store_meta
    end

    version :square do
      process resize_to_fill: [400, 400]
      process :store_meta
    end
  end

  model_delegate_attribute :crop_x
  model_delegate_attribute :crop_y
  model_delegate_attribute :crop_w
  model_delegate_attribute :crop_h

  # Crop processor
  def crop_to(width, height)
    # Checks that crop area is defined and crop should be done.
    if crop_args[0].eql?(crop_args[2]) || crop_args[1].eql?(crop_args[3])
      resize_to_fill(width, height)
    else
      args = crop_args + [width, height]
      crop_and_resize(*args)
    end
  end

  def crop_and_resize(x, y, width, height, new_width, new_height)
    manipulate! do |img|
      img.crop "#{width}x#{height}+#{x}+#{y}"
      img
    end
    resize_to_fill(new_width, new_height)
  end

  private

  def crop_args
    [model.crop_x.to_i, model.crop_y.to_i, model.crop_w.to_i, model.crop_h.to_i]
  end
end
