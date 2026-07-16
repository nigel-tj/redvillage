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

Docker Commands:
  docker:build          Build Docker image (development)
  docker:build:prod     Build Docker image for production
  docker:up              Start containers (development)
  docker:up:prod         Start production containers
  docker:down            Stop containers
  docker:down:prod       Stop production containers
  docker:logs            View container logs
  docker:logs:prod       View production container logs
  docker:console         Open Rails console in container
  docker:console:prod    Open Rails console in production container
  docker:migrate         Run migrations in container
  docker:migrate:prod    Run migrations in production container
  docker:shell           Open shell in container
  docker:shell:prod      Open shell in production container

Environment variables:
  RAILS_ENV=development|test|production
  PORT=3000 (for start/start:daemon)
  PIDFILE=tmp/pids/puma.pid (for daemon mode)
  DOCKER_COMPOSE_FILE=docker-compose.yml (override compose file)
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

# Prefer Docker Compose v2 plugin (`docker compose`); fall back to v1 binary.
docker_compose_bin() {
  if docker compose version &>/dev/null; then
    docker compose "$@"
  elif command -v docker-compose &>/dev/null; then
    docker-compose "$@"
  else
    echo "Docker Compose is not installed. Install Docker Compose v2 (docker compose)." >&2
    exit 1
  fi
}

# Docker helper functions
docker_compose() {
  local file="${DOCKER_COMPOSE_FILE:-docker-compose.yml}"
  docker_compose_bin -f "$file" "$@"
}

docker_compose_prod() {
  docker_compose_bin -f docker-compose.prod.yml "$@"
}

docker_build() {
  docker_compose build "$@"
}

docker_build_prod() {
  docker_compose_prod build "$@"
}

docker_up() {
  docker_compose up -d "$@"
}

docker_up_prod() {
  docker_compose_prod up -d "$@"
}

docker_down() {
  docker_compose down "$@"
}

docker_down_prod() {
  docker_compose_prod down "$@"
}

docker_logs() {
  docker_compose logs -f "$@"
}

docker_logs_prod() {
  docker_compose_prod logs -f "$@"
}

docker_exec() {
  local service="${1:-web}"
  shift
  docker_compose exec "$service" "$@"
}

docker_exec_prod() {
  local service="${1:-web}"
  shift
  docker_compose_prod exec "$service" "$@"
}

# Docker commands
docker_build_cmd() { docker_build; }
docker_build_prod_cmd() { docker_build_prod; }
docker_up_cmd() { docker_up; }
docker_up_prod_cmd() { docker_up_prod; }
docker_down_cmd() { docker_down; }
docker_down_prod_cmd() { docker_down_prod; }
docker_logs_cmd() { docker_logs; }
docker_logs_prod_cmd() { docker_logs_prod; }
docker_console() { docker_exec web bundle exec rails console; }
docker_console_prod() { docker_exec_prod web bundle exec rails console; }
docker_migrate() { docker_exec web bundle exec rails db:migrate; }
docker_migrate_prod() { docker_exec_prod web bundle exec rails db:migrate RAILS_ENV=production; }
docker_shell() { docker_exec web bash; }
docker_shell_prod() { docker_exec_prod web bash; }

cmd="${1:-}"; shift || true

case "$cmd" in
  setup)                  setup "$@" ;;
  update)                 update "$@" ;;
  start)                  start "$@" ;;
  start:daemon)           start_daemon "$@" ;;
  stop)                   stop "$@" ;;
  restart)                restart "$@" ;;
  status)                 status "$@" ;;
  console)                console "$@" ;;
  migrate)                migrate "$@" ;;
  db:setup)               db_setup "$@" ;;
  db:seed)                db_seed "$@" ;;
  assets:precompile)      assets_precompile "$@" ;;
  assets:clean)           assets_clean "$@" ;;
  logs)                   logs "$@" ;;
  docker:build)           docker_build_cmd "$@" ;;
  docker:build:prod)       docker_build_prod_cmd "$@" ;;
  docker:up)              docker_up_cmd "$@" ;;
  docker:up:prod)          docker_up_prod_cmd "$@" ;;
  docker:down)             docker_down_cmd "$@" ;;
  docker:down:prod)        docker_down_prod_cmd "$@" ;;
  docker:logs)             docker_logs_cmd "$@" ;;
  docker:logs:prod)        docker_logs_prod_cmd "$@" ;;
  docker:console)          docker_console "$@" ;;
  docker:console:prod)     docker_console_prod "$@" ;;
  docker:migrate)          docker_migrate "$@" ;;
  docker:migrate:prod)     docker_migrate_prod "$@" ;;
  docker:shell)            docker_shell "$@" ;;
  docker:shell:prod)       docker_shell_prod "$@" ;;
  -h|--help|help|"")       usage ;;
  *) echo "Unknown command: $cmd"; echo; usage; exit 1 ;;
esac


