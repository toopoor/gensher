module AssetsHelper
  def landing_image_path(source, name, path = 'img', options = {})
    landing_source = "#{name}/#{path}/#{source}"
    image_path(landing_source, options = {})
  end
end