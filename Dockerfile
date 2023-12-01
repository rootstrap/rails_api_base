ARG RUBY_VERSION=3.2.2
ARG NODE_VERSION=20.10.0

FROM node:$NODE_VERSION as node
FROM ruby:${RUBY_VERSION}

RUN apt-get update -qq && \
    apt-get install -y build-essential libssl-dev libpq-dev less vim nano libsasl2-dev
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Copy node binaries from node image
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /opt /opt

RUN node -v

# RUN mkdir -p /usr/local/lib/nodejs
# RUN tar -xJvf node-v$NODE_VERSION-linux-x64.tar.xz -C /usr/local/lib/nodejs 

# ENV WORK_ROOT /src
# ENV APP_HOME $WORK_ROOT/myapp/
# ENV LANG C.UTF-8
# ENV GEM_HOME $WORK_ROOT/bundle
# ENV BUNDLE_BIN $GEM_HOME/gems/bin
# ENV PATH $GEM_HOME/bin:$BUNDLE_BIN:$PATH

# RUN gem install bundler

# RUN mkdir -p $APP_HOME

# RUN bundle config --path=$GEM_HOME

# WORKDIR $APP_HOME

# ADD Gemfile ./
# ADD Gemfile.lock ./
# RUN bundle update --bundler
# RUN bundle install

# ADD package.json ./
# ADD yarn.lock ./

# RUN yarn install

# ADD . $APP_HOME

# EXPOSE 3000

# ENTRYPOINT bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
