require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Use UUID as the primary key for db records
    config.generators.orm :active_record, primary_key_type: :uuid

    # Eagerload lib classes
    config.eager_load_paths << Rails.root.join("lib")

    # Add tags to logs
    config.log_tags = %i[uuid remote_ip]

    # Available language codes
    config.i18n.available_locales = %i[en]

    # https://github.com/mperham/sidekiq/wiki/Active-Job
    config.active_job.queue_adapter = :sidekiq

    # Log to STDOUT
    STDOUT.sync = true
    logger           = ActiveSupport::Logger.new STDOUT
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new logger

    # Use Redis as cache store
    config.cache_store = :redis_cache_store, {
      url: ENV.fetch("REDIS_URL", "redis://localhost:6379/12"),
    }
  end
end
