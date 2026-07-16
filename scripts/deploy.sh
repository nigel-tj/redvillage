#!/usr/bin/env bash

set -euo pipefail

# Deployment script for production Docker environment
# Migrations run via container entrypoint on web start (single owner).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${SCRIPT_DIR%/scripts}"
cd "$ROOT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Prefer Docker Compose v2 plugin (`docker compose`); fall back to v1 binary.
docker_compose_bin() {
  if docker compose version &>/dev/null; then
    docker compose "$@"
  elif command -v docker-compose &>/dev/null; then
    docker-compose "$@"
  else
    log_error "Docker Compose is not installed. Install Docker Compose v2 (docker compose)."
    exit 1
  fi
}

compose_prod() {
  docker_compose_bin -f docker-compose.prod.yml "$@"
}

# Check if .env.production exists
if [ ! -f ".env.production" ]; then
  if [ -f ".env.production.example" ]; then
    log_warn ".env.production not found. Copying from .env.production.example..."
    cp .env.production.example .env.production
    log_warn "Please edit .env.production with your production credentials, then re-run."
    exit 1
  else
    log_error ".env.production is required. Copy .env.production.example and set real secrets."
    exit 1
  fi
fi

# Check Docker
if ! command -v docker &> /dev/null; then
  log_error "Docker is not installed. Please install Docker first."
  exit 1
fi

# Ensure compose is available
docker_compose_bin version >/dev/null

# Function to build and deploy
deploy() {
  log_info "Starting production deployment..."

  # Pull latest code if in git repository
  if [ -d ".git" ]; then
    log_info "Pulling latest code from repository..."
    git pull || log_warn "Failed to pull latest code. Continuing with current code..."
  fi

  # Build production image
  log_info "Building production Docker image..."
  compose_prod build --no-cache

  # Stop existing containers
  log_info "Stopping existing containers..."
  compose_prod down

  # Start containers (entrypoint runs db:migrate in production)
  log_info "Starting production containers..."
  compose_prod up -d

  # Wait briefly for health
  log_info "Waiting for services to become healthy..."
  sleep 10

  # Check if containers are running
  if compose_prod ps | grep -q "Up\|running"; then
    log_info "Deployment completed successfully!"
    log_info "Migrations run on web start via entrypoint. Check logs: ./scripts/manage.sh docker:logs:prod"
  else
    log_error "Deployment may have failed. Check logs with: ./scripts/manage.sh docker:logs:prod"
    exit 1
  fi
}

# Function to rollback
rollback() {
  log_warn "Rollback functionality not implemented yet."
  log_info "To rollback, you can:"
  log_info "1. Checkout previous version: git checkout <previous-commit>"
  log_info "2. Re-run deployment: ./scripts/deploy.sh"
}

# Function to show status
status() {
  log_info "Production container status:"
  compose_prod ps

  log_info "Production container logs (last 50 lines):"
  compose_prod logs --tail=50
}

# Main command handling
case "${1:-deploy}" in
  deploy)
    deploy
    ;;
  rollback)
    rollback
    ;;
  status)
    status
    ;;
  build)
    log_info "Building production Docker image..."
    compose_prod build
    ;;
  up)
    log_info "Starting production containers..."
    compose_prod up -d
    ;;
  down)
    log_info "Stopping production containers..."
    compose_prod down
    ;;
  logs)
    compose_prod logs -f
    ;;
  migrate)
    log_info "Running database migrations manually..."
    compose_prod exec -T web bundle exec rails db:migrate RAILS_ENV=production
    ;;
  console)
    compose_prod exec web bundle exec rails console
    ;;
  shell)
    compose_prod exec web bash
    ;;
  *)
    echo "Usage: $0 {deploy|rollback|status|build|up|down|logs|migrate|console|shell}"
    echo ""
    echo "Commands:"
    echo "  deploy    - Full deployment (build, stop, start; migrate via entrypoint)"
    echo "  rollback  - Rollback to previous version (not implemented)"
    echo "  status    - Show container status and recent logs"
    echo "  build     - Build production Docker image"
    echo "  up        - Start production containers"
    echo "  down      - Stop production containers"
    echo "  logs      - Follow production logs"
    echo "  migrate   - Run database migrations manually"
    echo "  console   - Open Rails console"
    echo "  shell     - Open shell in container"
    exit 1
    ;;
esac
