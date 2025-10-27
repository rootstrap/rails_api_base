#!/usr/bin/env bash

echo "Running release script" &&
  bundle exec rails feature_flags:initialize
