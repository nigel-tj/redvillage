#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Always run from repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${SCRIPT_DIR%/scripts}"
cd "$ROOT_DIR"

# Defaults
export RAILS_ENV="${RAILS_ENV:-development}"
export PORT="${PORT:-3000}"
PIDFILE="${PIDFILE:-tmp/pids/puma.pid}"

usage() {
  cat <<'USAGE'
Manage this Rails app

Usage:
  scripts/manage.sh <command> [args]

Commands:
  setup                 Bundle, DB setup, and prepare env
  update                Bundle and run migrations
  start                 Start Rails server (foreground)
  start:daemon          Start Puma as daemon with PID file
  stop                  Stop daemonized Puma (by PID or PORT)
  restart               Stop then start:daemon
  status                Show Puma/port status
  console               Open Rails console
  migrate               Run database migrations
  db:setup              rails db:setup
  db:seed               rails db:seed
  assets:precompile     Precompile assets
  assets:clean          Clobber compiled assets
  logs                  Tail development log

Environment variables:
  RAILS_ENV=development|test|production
  PORT=3000 (for start/start:daemon)
  PIDFILE=tmp/pids/puma.pid (for daemon mode)
USAGE
}

ensure_bundle() {
  # Prefer binstubs when available
  if [[ -x "bin/bundle" ]]; then
    BUNDLE="bin/bundle"
  else
    BUNDLE="bundle"
  fi
  if ! $BUNDLE check >/dev/null 2>&1; then
    $BUNDLE install --path vendor/bundle
  fi
}

rails_cmd() {
  if [[ -x "bin/rails" ]]; then
    bin/rails "$@"
  else
    bundle exec rails "$@"
  fi
}

puma_cmd() {
  if [[ -x "bin/puma" ]]; then
    bin/puma "$@"
  else
    bundle exec puma "$@"
  fi
}

start() {
  ensure_bundle
  rails_cmd server -b 0.0.0.0 -p "$PORT"
}

start_daemon() {
  ensure_bundle
  mkdir -p "$(dirname "$PIDFILE")"
  # If already running, refuse
  if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE" 2>/dev/null || echo 0)" 2>/dev/null; then
    echo "Already running (PID $(cat "$PIDFILE"))"
    return 0
  fi
  # Start rails server in background (Puma runs under rails s). Daemon mode was removed in Puma 7.
  nohup bash -lc "$(command -v bin/rails >/dev/null 2>&1 && echo bin/rails || echo bundle\ exec\ rails) server -b 0.0.0.0 -p $PORT" \
    >> "log/${RAILS_ENV}.log" 2>&1 &
  echo $! > "$PIDFILE"
  disown || true
  echo "Server started on :$PORT (PID $(cat "$PIDFILE"), pidfile: $PIDFILE)"
}

stop() {
  if [[ -f "$PIDFILE" ]]; then
    PID=$(cat "$PIDFILE" || true)
    if [[ -n "${PID:-}" ]] && kill -0 "$PID" 2>/dev/null; then
      kill "$PID"
      echo "Sent TERM to PID $PID"
      # Wait briefly then force kill if still alive
      sleep 2
      if kill -0 "$PID" 2>/dev/null; then
        kill -9 "$PID" || true
        echo "Force killed PID $PID"
      fi
    fi
    rm -f "$PIDFILE"
    return 0
  fi

  # Fallback: kill any process bound to PORT
  if command -v lsof >/dev/null 2>&1; then
    PIDS=$(lsof -t -iTCP:"$PORT" -sTCP:LISTEN || true)
    if [[ -n "${PIDS:-}" ]]; then
      while IFS= read -r p; do
        [[ -n "$p" ]] && kill "$p" 2>/dev/null || true
      done <<< "$PIDS"
      echo "Stopped process(es) on port $PORT (PID(s): $PIDS)"
      return 0
    fi
  fi
  echo "No running daemon found (pidfile or port)"
}

restart() {
  stop || true
  start_daemon
}

status() {
  if [[ -f "$PIDFILE" ]]; then
    PID=$(cat "$PIDFILE" || true)
    if [[ -n "${PID:-}" ]] && kill -0 "$PID" 2>/dev/null; then
      echo "Puma running (PID $PID) using $PIDFILE"
      return 0
    fi
  fi
  if command -v lsof >/dev/null 2>&1; then
    if lsof -Pi :"$PORT" -sTCP:LISTEN -n; then
      return 0
    fi
  fi
  echo "Not running"
  return 1
}

setup() {
  ensure_bundle
  rails_cmd db:setup
  echo "Setup complete"
}

update() {
  ensure_bundle
  rails_cmd db:migrate
  echo "Update complete"
}

migrate() { ensure_bundle; rails_cmd db:migrate; }
db_setup() { ensure_bundle; rails_cmd db:setup; }
db_seed() { ensure_bundle; rails_cmd db:seed; }
assets_precompile() { ensure_bundle; rails_cmd assets:precompile; }
assets_clean() { ensure_bundle; rails_cmd assets:clobber; }
console() { ensure_bundle; rails_cmd console; }
logs() { tail -f "log/${RAILS_ENV}.log"; }

cmd="${1:-}"; shift || true

case "$cmd" in
  setup)              setup "$@" ;;
  update)             update "$@" ;;
  start)              start "$@" ;;
  start:daemon)       start_daemon "$@" ;;
  stop)               stop "$@" ;;
  restart)            restart "$@" ;;
  status)             status "$@" ;;
  console)            console "$@" ;;
  migrate)            migrate "$@" ;;
  db:setup)           db_setup "$@" ;;
  db:seed)            db_seed "$@" ;;
  assets:precompile)  assets_precompile "$@" ;;
  assets:clean)       assets_clean "$@" ;;
  logs)               logs "$@" ;;
  -h|--help|help|"") usage ;;
  *) echo "Unknown command: $cmd"; echo; usage; exit 1 ;;
esac


