FROM ruby:2.6.3

LABEL Name=rails_api_base Version=1.0

ENV PATH=/app/bin:$PATH

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libxml2

# Install heroku cli
RUN curl https://cli-assets.heroku.com/install.sh | sh

RUN mkdir /gems
ENV BUNDLE_PATH "/gems"

RUN mkdir /app
WORKDIR /app

# Install Node.js with npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt -y install nodejs
RUN apt -y install gcc g++ make cmake

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

# Install bundler
RUN gem install bundler:2.0.2

# Install nano text editor
RUN apt install nano

WORKDIR /app

# Add application binaries
ADD ./bin /app/bin

# Install gems
ADD Gemfile Gemfile.lock ./
RUN ./bin/bundle install

# Install node modules
ADD package.json yarn.lock ./
RUN yarn install --check-files

ADD . /app/

EXPOSE 3000

ENTRYPOINT bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
