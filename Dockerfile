FROM ruby:2.6.3

LABEL Name=rails_api_base Version=1.0

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
RUN apt -y  install gcc g++ make cmake

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

RUN apt install nano

# Install rails globally
RUN gem install rails -v 6.0.0

WORKDIR /app

ADD Gemfile Gemfile.lock ./
RUN bundle install
RUN yarn install --check-files


ADD . /app/
EXPOSE 3000
CMD rm -f tmp/pids/server.pid &&  bundle exec rails s -b 0.0.0.0 -p 3000
