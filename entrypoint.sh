#!/bin/bash
set -euo pipefail

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid
rm -f /app/tmp/pids/puma.pid

mkdir -p /app/tmp/pids /app/tmp/cache /app/log /app/storage

db_configured() {
  [ -n "${DATABASE_URL:-}" ] || [ -n "${DATABASE_HOST:-}" ]
}

# Wait for database when connection settings are present
if db_configured; then
  echo "Waiting for database to be ready..."
  max_attempts="${DB_WAIT_ATTEMPTS:-30}"
  attempt=0
  until bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')" >/dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge "$max_attempts" ]; then
      echo "Database connection failed after ${max_attempts} attempts"
      exit 1
    fi
    echo "Database is unavailable - sleeping (attempt ${attempt}/${max_attempts})"
    sleep 2
  done
  echo "Database is ready!"
fi

# Migrations: prefer Fly release_command (see fly.toml). Opt-in here for
# non-Fly hosts or emergency boots via RUN_MIGRATIONS=true.
if [ "${RAILS_ENV:-development}" = "production" ] && [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
  if ! db_configured; then
    echo "RUN_MIGRATIONS=true but no DATABASE_URL/DATABASE_HOST set" >&2
    exit 1
  fi
  echo "Running database migrations (RUN_MIGRATIONS=true)..."
  bundle exec rails db:prepare
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
