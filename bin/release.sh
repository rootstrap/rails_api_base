#!/usr/bin/env bash

bundle exec rails db:migrate
bundle exec rails feature_flags:initialize
