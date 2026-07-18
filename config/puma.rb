# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS", 3))
threads threads_count, threads_count

# Single bind — do not also call `port` (that can open a second listener).
# Fly sets PORT (typically 8080).
app_port = Integer(ENV.fetch("PORT", 3000))
bind "tcp://0.0.0.0:#{app_port}"

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Production-specific settings
if ENV["RAILS_ENV"] == "production"
  # Keep worker count low on small Fly VMs (override with WEB_CONCURRENCY).
  workers Integer(ENV.fetch("WEB_CONCURRENCY", 1))

  # Preload the app for better performance with workers.
  preload_app!

  # Keep logs on stdout when Fly/Docker requests it (default in our Dockerfile).
  if ENV["RAILS_LOG_TO_STDOUT"] != "true"
    stdout_redirect "log/puma.stdout.log", "log/puma.stderr.log", true
  end

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end

  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end
