ARG RUBY_VERSION=3.2.2
ARG NODE_VERSION=20.10.0

FROM node:$NODE_VERSION as node
FROM ruby:${RUBY_VERSION}

RUN apt-get update -qq && \
    apt-get install -y build-essential libssl-dev libpq-dev vim libsasl2-dev

# Copy node binaries from node image
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /opt /opt

ENV WORK_ROOT /src
ENV APP_HOME $WORK_ROOT/myapp/
ENV LANG C.UTF-8
ENV GEM_HOME $WORK_ROOT/bundle

RUN mkdir -p $APP_HOME

RUN bundle config --path=$GEM_HOME

WORKDIR $APP_HOME

COPY --link Gemfile Gemfile.lock ./


RUN gem install bundler 
RUN bundle install

COPY --link package.json yarn.lock ./


RUN yarn install

ADD . $APP_HOME

# EXPOSE 3000

# ENTRYPOINT bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
CMD bundle exec rails s -b 0.0.0.0
