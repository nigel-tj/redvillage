# Environment Setup Guide

## Production Environment Variables

Copy the production template and replace placeholders with real secrets:

```bash
cp .env.production.example .env.production
chmod 600 .env.production
# Edit .env.production with your production values
```

Required variables (also documented in `.env.production.example`):

```bash
# Database Configuration
DATABASE_USERNAME=redvillage
DATABASE_PASSWORD=your_secure_password
DATABASE_HOST=db

# MySQL Root Password (for docker compose)
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_DATABASE=redvillage_production
MYSQL_USER=redvillage
MYSQL_PASSWORD=your_secure_password

# Rails Configuration
RAILS_ENV=production
RACK_ENV=production
RAILS_MAX_THREADS=5
RAILS_SERVE_STATIC_FILES=false
RAILS_LOG_TO_STDOUT=true
RAILS_LOG_LEVEL=info

# Application Secrets
# Generate with: rails secret
SECRET_KEY_BASE=your_generated_secret_key_base

# Server Configuration
PORT=3000
WEB_CONCURRENCY=2

# Optional: External Services
# STRIPE_PUBLIC_KEY=your_stripe_public_key
# STRIPE_SECRET_KEY=your_stripe_secret_key

# Optional: Email Configuration (if using ActionMailer)
# SMTP_HOST=smtp.example.com
# SMTP_PORT=587
# SMTP_USERNAME=your_smtp_username
# SMTP_PASSWORD=your_smtp_password
# SMTP_FROM_ADDRESS=noreply@example.com

# Optional: Domain Configuration
# DOMAIN=yourdomain.com
# FORCE_SSL=true
```

`docker-compose.prod.yml` requires `MYSQL_ROOT_PASSWORD` and `DATABASE_PASSWORD` to be set (no insecure defaults).

## Generating SECRET_KEY_BASE

To generate a secure `SECRET_KEY_BASE`:

```bash
# Using Rails
docker run --rm -it ruby:3.2.2-slim bash -c "gem install rails -v 7.2 && rails secret"

# Or using Ruby directly
docker run --rm ruby:3.2.2-slim ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"
```

## Security Notes

- Never commit `.env.production` to version control
- Use strong, unique passwords for database credentials
- Rotate secrets regularly
- Consider using a secrets management service in production
- Keep `.env.production` file permissions restricted (chmod 600)
