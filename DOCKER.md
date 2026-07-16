# Docker Deployment Guide

This document describes how to build and deploy the Red Village application using Docker in production.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Linux production server (Ubuntu 20.04+ recommended)

## Quick Start

### 1. Setup Environment Variables

Create a `.env.production` file in the project root:

```bash
cp .env.production.example .env.production
# Edit .env.production with your production values
```

Required variables:
- `DATABASE_USERNAME` - MySQL database username
- `DATABASE_PASSWORD` - MySQL database password
- `SECRET_KEY_BASE` - Rails secret key (generate with: `rails secret`)

### 2. Build and Deploy

Using the deployment script:

```bash
./scripts/deploy.sh
```

Or manually:

```bash
# Build production image
docker compose -f docker-compose.prod.yml build

# Start services (entrypoint runs db:migrate in production)
docker compose -f docker-compose.prod.yml up -d

# Optional: run migrations manually if needed
docker compose -f docker-compose.prod.yml exec web rails db:migrate RAILS_ENV=production
```

### 3. Verify Deployment

Check container status:
```bash
docker compose -f docker-compose.prod.yml ps
```

View logs:
```bash
docker compose -f docker-compose.prod.yml logs -f
```

## Using the Management Scripts

### Development Commands

```bash
# Build development image
./scripts/manage.sh docker:build

# Start development containers
./scripts/manage.sh docker:up

# View logs
./scripts/manage.sh docker:logs

# Open Rails console
./scripts/manage.sh docker:console

# Run migrations
./scripts/manage.sh docker:migrate

# Stop containers
./scripts/manage.sh docker:down
```

### Production Commands

```bash
# Build production image
./scripts/manage.sh docker:build:prod

# Start production containers
./scripts/manage.sh docker:up:prod

# View production logs
./scripts/manage.sh docker:logs:prod

# Open Rails console in production
./scripts/manage.sh docker:console:prod

# Run production migrations
./scripts/manage.sh docker:migrate:prod

# Stop production containers
./scripts/manage.sh docker:down:prod
```

## Deployment Script

The `scripts/deploy.sh` script automates the full deployment process:

```bash
./scripts/deploy.sh deploy      # Full deployment (migrate via entrypoint on web start)
./scripts/deploy.sh build       # Build only
./scripts/deploy.sh up          # Start containers
./scripts/deploy.sh down        # Stop containers
./scripts/deploy.sh logs        # View logs
./scripts/deploy.sh migrate     # Run migrations manually
./scripts/deploy.sh console     # Open console
./scripts/deploy.sh status      # Show status
```

Requires Docker Compose **v2** (`docker compose`). Scripts auto-detect v2 and fall back to the legacy `docker-compose` binary if present.

## Production Configuration

### Database

The production setup uses MySQL 8.0. Database credentials should be set in `.env.production`:

- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE`

### Application Server

The application runs on Puma with the following defaults:
- Workers: 2 (configurable via `WEB_CONCURRENCY`)
- Threads: 5 per worker (configurable via `RAILS_MAX_THREADS`)
- Port: 3000 (internal, use nginx reverse proxy)

### Static Files

By default, Rails serves static files in Docker. For production behind nginx, set:
```
RAILS_SERVE_STATIC_FILES=false
```

And configure nginx to serve from `/app/public`.

### Logging

Logs are configured to output to stdout by default (`RAILS_LOG_TO_STDOUT=true`), which allows Docker to capture them.

## Reverse Proxy (Nginx)

It's recommended to use nginx as a reverse proxy. Example configuration:

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /cable {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}
```

## Updating the Application

To update the application:

1. Pull latest code: `git pull`
2. Rebuild and deploy: `./scripts/deploy.sh deploy`

The deployment script will:
- Build new Docker image
- Stop existing containers
- Start new containers
- Run database migrations

## Backup and Restore

### Database Backup

```bash
docker compose -f docker-compose.prod.yml exec db mysqldump -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} > backup_$(date +%Y%m%d).sql
```

### Database Restore

```bash
docker compose -f docker-compose.prod.yml exec -T db mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < backup_YYYYMMDD.sql
```

### File Uploads Backup

File uploads are stored in Docker volumes. To backup:

```bash
docker run --rm -v redvillage_uploads_production:/data -v $(pwd):/backup ubuntu tar czf /backup/uploads_backup.tar.gz /data
```

## Troubleshooting

### Container won't start

Check logs:
```bash
docker compose -f docker-compose.prod.yml logs web
```

### Database connection issues

Verify database credentials in `.env.production` and ensure the database container is running:
```bash
docker compose -f docker-compose.prod.yml ps db
```

### Migration errors

Run migrations manually:
```bash
docker compose -f docker-compose.prod.yml exec web rails db:migrate RAILS_ENV=production
```

### Out of memory

Increase Docker memory limits or reduce `WEB_CONCURRENCY` in `.env.production`.

## Security Considerations

1. **Set real passwords** - `.env.production` must define strong `MYSQL_ROOT_PASSWORD` and `DATABASE_PASSWORD` (compose refuses insecure defaults)
2. **Use secrets management** - Consider using Docker secrets or external secret management
3. **Firewall** - Only expose port 3000 to localhost, use nginx reverse proxy
4. **SSL/TLS** - Use Let's Encrypt with Certbot for SSL certificates
5. **Regular updates** - Keep Docker images and base images updated
6. **Database access** - Restrict database access to application container only

## Monitoring

### Health Checks

The production setup includes health checks:
- Database: MySQL ping check
- Web: HTTP GET /up endpoint

Check health status:
```bash
docker compose -f docker-compose.prod.yml ps
```

### Resource Usage

Monitor resource usage:
```bash
docker stats
```

## Scaling

To scale the application horizontally:

1. Use a load balancer (nginx, HAProxy)
2. Run multiple web container instances
3. Use external MySQL or managed database service
4. Consider using Docker Swarm or Kubernetes for orchestration

Example with docker compose:
```bash
docker compose -f docker-compose.prod.yml up -d --scale web=3
```


