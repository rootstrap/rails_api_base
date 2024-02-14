ARG RUBY_VERSION=3.2.2
ARG NODE_VERSION=20.10.0

# Use Node image so we can pull the binaries from here.
FROM node:$NODE_VERSION as node

# Ruby build image.
FROM ruby:${RUBY_VERSION}

RUN apt-get update -qq && \
    apt-get install -y build-essential libssl-dev libpq-dev vim libsasl2-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy node binaries from node image.
COPY --from=node /usr/local /usr/local
COPY --from=node /opt /opt

# Setup environment variables.
ENV WORK_ROOT /src
ENV APP_HOME $WORK_ROOT/app/
ENV LANG C.UTF-8
ENV BUNDLE_PATH $WORK_ROOT/bundle

# Create app directory.
RUN mkdir -p $APP_HOME

# Setup work directory.
WORKDIR $APP_HOME

# Copy dependencies files and install libraries.
COPY --link Gemfile Gemfile.lock package.json yarn.lock ./
RUN gem install bundler && bundle install -j 4 && yarn install

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
