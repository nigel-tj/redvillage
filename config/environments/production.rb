require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Serve precompiled assets from public/ (required on Fly; there is no separate nginx).
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present? || ENV["FLY_APP_NAME"].present?

  # sassc-rails enables :sass compression by default, but SassC chokes on
  # modern CSS (e.g. min(70vh, 640px) / clamp()) during assets:precompile.
  config.assets.css_compressor = nil

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Local disk is ephemeral on Fly — uploads are lost on redeploy unless you
  # attach a volume or switch to S3-compatible storage.
  config.active_storage.service = :local

  # Fly terminates TLS at the proxy; trust X-Forwarded-Proto / assume HTTPS.
  config.assume_ssl = true
  config.force_ssl = true

  # Fly (and Docker) health checks hit /up over plain HTTP inside the private network.
  config.ssl_options = {
    redirect: { exclude: ->(request) { request.path == "/up" } }
  }

  # Log to STDOUT (Fly captures process stdout).
  config.logger = ActiveSupport::Logger.new($stdout)
    .tap { |logger| logger.formatter = Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "redvillage_production"

  config.action_mailer.perform_caching = false

  # Enable locale fallbacks for I18n.
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Allow Fly default hostname + optional custom APP_HOST.
  config.hosts << /.*\.fly\.dev\z/
  config.hosts << ENV["APP_HOST"] if ENV["APP_HOST"].present?

  # Skip host checks for the health endpoint.
  config.host_authorization = {
    exclude: ->(request) { request.path == "/up" }
  }
end
