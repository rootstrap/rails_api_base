#!/usr/bin/env bash

rake db: migrate
rake feature_flags: initialize
