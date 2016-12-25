# encoding: utf-8
CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\_\-\+\s\:]/
CarrierWave.configure do |config|
  config.storage = :file
  config.asset_host = ActionController::Base.asset_host

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
