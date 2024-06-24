ARG RUBY_VERSION=3.3.3
ARG NODE_VERSION=20.10.0
ARG YARN_VERSION=1.22.19

# Use Node image so we can pull the binaries from here.
FROM node:$NODE_VERSION as node

# Ruby build image.
FROM ruby:${RUBY_VERSION}-slim as base

# Setup environment variables.
ENV WORK_ROOT /src
ENV APP_HOME $WORK_ROOT/app
ENV LANG C.UTF-8
ENV BUNDLE_PATH $APP_HOME/vendor/bundle

# Set prod environment to avoid installing dev dependencies
ENV BUNDLE_WITHOUT development:test
ENV BUNDLE_DEPLOYMENT 1
ENV RAILS_ENV production
ENV NODE_ENV production

# Throw-away build stage to reduce size of final image
FROM base as builder

RUN apt-get update -qq && \
    apt-get install -y build-essential libssl-dev libpq-dev git libsasl2-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy node binaries from node image.
COPY --from=node /usr/local /usr/local
COPY --from=node /opt /opt

# Create app directory.
RUN mkdir -p $APP_HOME

# Setup work directory.
WORKDIR $APP_HOME

# Copy dependencies files and install libraries.
COPY --link Gemfile Gemfile.lock package.json yarn.lock ./

RUN gem install bundler && bundle install -j 4 && yarn install --frozen-lockfile && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

# Copy application code
COPY --link . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE=DUMMY ./bin/rails assets:precompile

# Build runtime image.
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libpq-dev libvips libjemalloc2 && \
    apt-get clean

# Create app directory.
RUN mkdir -p $APP_HOME

# Setup work directory.
WORKDIR $APP_HOME

# Copy everything from the builder image
COPY --link . .
COPY --from=builder $APP_HOME/public/ $APP_HOME/public/
COPY --from=builder $APP_HOME/tmp/ $APP_HOME/tmp/
COPY --from=builder $APP_HOME/vendor/ $APP_HOME/vendor/

RUN ln -s /usr/lib/*-linux-gnu/libjemalloc.so.2 /usr/lib/libjemalloc.so.2

# Deployment options
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV LD_PRELOAD=/usr/lib/libjemalloc.so.2

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
