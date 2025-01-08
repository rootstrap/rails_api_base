#!/usr/bin/env bash

git config --global --add safe.directory /github/workspace
chmod +x ./cc-test-reporter
./cc-test-reporter format-coverage --output "coverage/coverage.${CI_NODE_INDEX}.json"
