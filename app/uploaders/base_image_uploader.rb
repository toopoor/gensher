# encoding: utf-8
# :nodoc:
class BaseImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Meta

  process :fix_exif_rotation
  process :watermark

  def extension_white_list
    %w(jpg jpeg png gif)
  end

  def dynamic_resize_to_fill
    manipulate! do |img|
      dynamic_width, dynamic_height = size_from_model
      img = img.resize "#{dynamic_width}x#{dynamic_height}"
      img = yield(img) if block_given?
      self.width  = dynamic_width
      self.height = dynamic_height
      img
    end
  end

  def from_orientation(portrait, landscape)
    manipulate! do |img|
      w, h = get_dimensions
      width, height = w > h ? landscape : portrait
      img.resize "#{width}x#{height}>"
      img
    end
  end

  def resize_and_crop(h2, w_max = 2880)
    manipulate! do |image|
      w, h = get_dimensions
      w2 = w > w_max ? w_max : w
      image = image.resize "#{w2}x"
      y = h > h2 ? (h - h2).abs / 2 : 0
      image = image.crop("#{w}x#{h2}+0+#{y}")
      image
    end
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end

  def watermark(path_to_file = 'watermark.png')
    return unless model.class.respond_to?(:with_watermark) &&
                  model.class.with_watermark
    watermark_path = File.join(Rails.root, 'public', path_to_file)
    manipulate! do |img|
      img = img.composite(MiniMagick::Image.open(watermark_path), 'jpg') do |c|
        c.gravity 'SouthEast'
      end
      img
    end
  end

  def store_crop
    manipulate! do |img|
      return unless crop_args.map(&:present?).inject(&:&)
      x, y, w, h = crop_args
      self.image_crop_w = w
      self.image_crop_h = h
      self.image_crop_x = x
      self.image_crop_y = y
      img
    end
  end

  private

  def crop_args
    %w(x y w h).map do |accessor|
      (model.send('image_crop_' + accessor) ||
        send('image_crop_' + accessor)).to_i
    end
  end

  def size_from_model
    %w(width height).map do |accessor|
      (model.send(accessor) || send(accessor)).to_i
    end
  end
end
