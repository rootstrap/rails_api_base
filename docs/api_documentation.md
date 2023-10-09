# API Docs

## Generating Docs
A [Check Docs](./.github/workflows/check_docs.yml) action is provided to check the request specs pass and the docs don't have missing changes.

This action is triggered when the PR is labeled with `doc` and on pushes to main.
An autolabeler action takes care of labeling for any PR that changes the `spec/requests/api` files, but if you wish to run this against any PR just add the label manually.

### Parallelization caveats
We use a default of 8 cores in the  workflow so if you're running this locally make sure to run with `PARALLEL_TESTS_CONCURRENCY=8`. If you wish to change this just update the workflow to the desired amount, if not you will have data changes in the generated docs.

If you wish to run everything without parallelization make the following change:
```diff
  name: Setup Database
- run: bundle exec rake parallel:load_schema[8]
+ run: bundle exec rails db:setup
  name: Run tests and update docs
-  env:
-    PARALLEL_TESTS_CONCURRENCY: 8
  run: bundle exec ./bin/update-docs.rb && git diff
```
