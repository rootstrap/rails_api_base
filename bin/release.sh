#!/usr/bin/env bash

bundle exec rake db:migrate
bundle exec rake feature_flags:initialize
