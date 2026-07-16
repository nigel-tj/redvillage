# Multi-stage Dockerfile for production optimization
FROM ruby:3.2.2-slim as builder

# Install essential build dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    default-mysql-client \
    default-libmysqlclient-dev \
    imagemagick \
    libmagickwand-dev \
    ffmpeg \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config --global frozen 1 && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem

# Copy application code
COPY . .

# Precompile assets
RUN RAILS_ENV=production SECRET_KEY_BASE=dummy bundle exec rails assets:precompile && \
    rm -rf tmp/cache

# Production stage
FROM ruby:3.2.2-slim

# Install runtime dependencies only
RUN apt-get update -qq && apt-get install -y \
    default-mysql-client \
    default-libmysqlclient-dev \
    imagemagick \
    libmagickwand-dev \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create app user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /app

# Copy gems from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy application code
COPY --from=builder /app /app

# Copy entrypoint script
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Set ownership
RUN chown -R appuser:appuser /app

# Switch to app user
USER appuser

# Expose port
EXPOSE 3000

# Set environment
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Use Puma as production server
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
