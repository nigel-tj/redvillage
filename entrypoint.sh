#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid
rm -f /app/tmp/pids/puma.pid

# Wait for database to be ready (only if DATABASE_HOST is set)
if [ -n "${DATABASE_HOST:-}" ]; then
  echo "Waiting for database to be ready..."
  max_attempts=30
  attempt=0
  until bundle exec rails runner "ActiveRecord::Base.connection" 2>/dev/null; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
      echo "Database connection failed after $max_attempts attempts"
      exit 1
    fi
    echo "Database is unavailable - sleeping (attempt $attempt/$max_attempts)"
    sleep 2
  done
  echo "Database is ready!"
fi

# Run database migrations in production (single owner; fail hard on error)
if [ "${RAILS_ENV:-development}" = "production" ]; then
  echo "Running database migrations..."
  bundle exec rails db:migrate
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
