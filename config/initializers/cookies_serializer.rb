# Be sure to restart your server when you modify this file.
Rails.application.routes.default_url_options[:host] = ENV['APP_HOST']
Rails.application.config.action_dispatch.cookies_serializer = :json