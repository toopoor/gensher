require File.expand_path('../boot', __FILE__)

require 'rails/all'
Bundler.require(*Rails.groups)

module Gensherman
  class Application < Rails::Application
    config.middleware.use Rack::Affiliates, ttl: 6.months
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths << Rails.root.join('app/jobs')

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.paths << Rails.root.join('app', 'assets', 'landings')
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :delayed_job

    config.generators do |g|
      g.test_framework :rspec, views: false, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :haml
      g.stylesheets false
      # don't generate RSpec tests for views and helpers
      g.view_specs false
      g.helper_specs false
    end

    config.i18n.locale = :ru
    config.i18n.default_locale = :ru
  end
end
