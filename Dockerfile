# Multi-stage Dockerfile for Fly.io / production
FROM ruby:3.2.2-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_ENV=production

# Build deps for native gems (mysql2, rmagick, sassc, etc.)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      nodejs \
      default-libmysqlclient-dev \
      pkg-config \
      shared-mime-info \
      imagemagick \
      libmagickwand-dev \
      ffmpeg \
      git \
      curl \
      libyaml-dev \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Lockfile was generated with Bundler 2.6.9; ruby:3.2.2-slim ships an older one
RUN gem install bundler -v 2.6.9

COPY Gemfile Gemfile.lock ./

# Do NOT use frozen/deployment mode here: a Gemfile vs Gemfile.lock
# constraint mismatch (e.g. dockerfile-rails) will fail the whole build.
# Install only production gems; lockfile is still preferred when compatible.
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf "${BUNDLE_PATH}"/cache/*.gem /tmp/*

COPY . .

# Dummy secret is enough for asset compilation at build time.
# css_compressor must stay disabled in production.rb (SassC breaks on modern CSS).
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile && \
    rm -rf tmp/cache node_modules

# ---------------------------------------------------------------------------
FROM ruby:3.2.2-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    PORT=8080

# Runtime libs only (no build-essential)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      default-mysql-client \
      default-libmysqlclient-dev \
      shared-mime-info \
      imagemagick \
      libmagickwand-6.q16-6 \
      ffmpeg \
      curl \
      libyaml-0-2 \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --system --gid 1000 appuser && \
    useradd --system --uid 1000 --gid appuser --create-home --home-dir /home/appuser appuser

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh && \
    mkdir -p tmp/pids tmp/cache log storage && \
    chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
