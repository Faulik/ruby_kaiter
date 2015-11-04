require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyKaiter
  class Application < Rails::Application
    config.paths.add 'app/api', glob: '**/*.rb'
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]
    
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.insert_before 0 ,"Rack::Cors", debug: false, logger: (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '/api/*',
          headers: :any,
          methods: [:get, :post, :delete, :put, :patch, :options, :head],
          credentials: true,
          max_age: 0
      end
    end

    config.generators do |g|
      g.test_framework :rspec
      g.stylesheets false
      g.javascripts false        
    end
  end
end
