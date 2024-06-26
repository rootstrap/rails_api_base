# Rails API Template

[![Github Actions CI](https://github.com/rootstrap/rails_api_base/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/rootstrap/rails_api_base/actions)
[![Code Climate](https://codeclimate.com/github/rootstrap/rails_api_base/badges/gpa.svg)](https://codeclimate.com/github/rootstrap/rails_api_base)
[![Test Coverage](https://api.codeclimate.com/v1/badges/63de7f82c79f5fe82f46/test_coverage)](https://codeclimate.com/github/rootstrap/rails_api_base/test_coverage)

Rails API Base is a boilerplate project for JSON RESTful APIs. It follows the community best practices in terms of standards, security and maintainability, integrating a variety of testing and code quality tools. It's based on Rails 7.1 and Ruby 3.3.

Finally, it contains a plug an play Administration console (thanks to [ActiveAdmin](https://github.com/activeadmin/activeadmin)).

## Features

This template comes with:
- Schema
  - Users table
  - Admin users table
- Endpoints
  - Sign up with user credentials
  - Sign in with user credentials
  - Sign out
  - Reset password
  - Get and update user profile
- Administration panel
- Feature flags support with a UI for management
- Code quality tools
- RSpec tests
- RSpec API Doc Generator
- API documentation following [OpenAPI](https://www.openapis.org/)
- Docker support

## How to use

1. Clone this repo
1. Install PostgreSQL in case you don't have it
1. Install node and yarn. Expected node version ">=16 || 14 >=14.17".
1. Run `bootstrap.sh` with the name of your project like `./bin/bootstrap.sh --name=my_awesome_project`
1. Run `yarn install` and `yarn build --watch`. This bundles the JS assets in the administration site using [esbuild](https://github.com/evanw/esbuild).
1. `bundle exec rspec` and make sure all tests pass (non-headless mode) or `HEADLESS=true bundle exec rspec` (headless mode)
1. Run `bin/dev`.
1. You can now try your REST services!

## How to use with Docker

1. Have `docker` and `docker-compose` installed (You can check this by doing `docker -v` and `docker-compose -v`)
1. Run `bootstrap.sh` with the name of your project and the `-d` or `--for-docker` flag like `./bin/bootstrap.sh --name=my_awesome_project -d`
    1. Run `./bin/bootstrap.sh --help` for the full details.
1. (Optional) If you want to deny access to the database from outside of the `docker-compose` network, remove the `ports` key in the `docker-compose.yml` from the `db` service.
1. (Optional) Run the tests to make sure everything is working with: `bin/rspec .`.
1. You can now try your REST services!

See [Docker docs](./docs/docker.md) for more info

## Dev scripts

This template provides a handful of scripts to make your dev experience better!

- bin/bundle to run any `bundle` commands.
  - `bin/bundle install`
- bin/rails to run any `rails` commands
  - `bin/rails console`
- bin/web to run any `bash` commands
  - `bin/web ls`
- bin/rspec to run specs
  - `bin/rspec .`
- bin/dev to run both Rails and JS build processes at the same time in a single terminal tab.
  - `bin/dev`

You don't have to use these but they are designed to run the same when running with Docker or not.
To illustrate, `bin/rails console` will run the console in the docker container when running with docker and locally when not.

## Gems

- [ActiveAdmin](https://github.com/activeadmin/activeadmin) for easy administration
- [Arctic Admin](https://github.com/cprodhomme/arctic_admin) for responsive active admin
- [Annotate](https://github.com/ctran/annotate_models) for documenting the schema in the classes
- [Better Errors](https://github.com/charliesome/better_errors) for a better error page
- [Brakeman](https://github.com/presidentbeef/brakeman) for security static analysis
- [Byebug](https://github.com/deivid-rodriguez/byebug) for debugging
- [DelayedJob](https://github.com/collectiveidea/delayed_job) for background processing
- [Devise](https://github.com/plataformatec/devise) for basic authentication
- [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) for API authentication
- [Dotenv](https://github.com/bkeepers/dotenv) for handling environment variables
- [Draper](https://github.com/drapergem/draper) for decorators
- [Factory Bot](https://github.com/thoughtbot/factory_bot) for testing data
- [Faker](https://github.com/stympy/faker) for generating test data
- [Flipper](https://github.com/jnunemaker/flipper) for feature flag support
- [Jbuilder](https://github.com/rails/jbuilder) for JSON views
- [JS Bundling](https://github.com/rails/jsbundling-rails) for bundling JS assets
- [Knapsack](https://github.com/KnapsackPro/knapsack) for splitting tests evenly based on execution time
- [Letter Opener](https://github.com/ryanb/letter_opener) for previewing emails in the browser
- [New Relic](https://github.com/newrelic/newrelic-ruby-agent) for monitoring and debugging
- [Oj](https://github.com/ohler55/oj) for optimized JSON
- [Pagy](https://github.com/ddnexus/pagy) for pagination
- [Parallel Tests](https://github.com/grosser/parallel_tests) for running the tests in multiple cores
- [Prosopite](https://github.com/charkost/prosopite) to detect N+1 queries
- [Pry](https://github.com/pry/pry) for enhancing the Ruby shell
- [Puma](https://github.com/puma/puma) for the web server
- [Pundit](https://github.com/varvet/pundit) for authorization management
- [Rack CORS](https://github.com/cyu/rack-cors) for handling CORS
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices) for Rails linting
- [Reek](https://github.com/troessner/reek) for Ruby linting
- [RSpec](https://github.com/rspec/rspec) for testing
- [RSpec OpenAPI](https://github.com/exoego/rspec-openapi) for generating API documentation
- [Rswag](https://github.com/rswag/rswag) for serving the API documentation
- [Rubocop](https://github.com/bbatsov/rubocop/) for Ruby linting
- [Sendgrid](https://github.com/stephenb/sendgrid) for sending emails
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for other testing matchers
- [Simplecov](https://github.com/colszowka/simplecov) for code coverage
- [Strong Migrations](https://github.com/ankane/strong_migrations) for catching unsafe migrations in development
- [Webmock](https://github.com/bblimke/webmock) for stubbing http requests
- [YAAF](https://github.com/rootstrap/yaaf) for form objects

## Optional configuration

- Set your [frontend URL](https://github.com/cyu/rack-cors#origin) in `config/initializers/rack_cors.rb`
- Set your mail sender in `config/initializers/devise.rb`
- Config your timezone accordingly in `application.rb`
- Config CI parallel execution. See [docs](docs/ci.md)
- Fullstack development. See [docs](docs/fullstack.md).

## API Docs

- [RSpec API Doc Generator](https://github.com/exoego/rspec-openapi) you can generate the docs after writing requests specs
- [Rswag](https://github.com/rswag/rswag) you can expose the generated docs

See [API documentation docs](./docs/api_documentation.md) for more info

## Code quality

With `bundle exec rails code:analysis` you can run the code analysis tool, you can omit rules with:

- [Rubocop](https://github.com/bbatsov/rubocop/blob/master/config/default.yml) Edit `.rubocop.yml`
- [Reek](https://github.com/troessner/reek#configuration-file) Edit `config.reek`
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices#custom-configuration) Edit `config/rails_best_practices.yml`
- [Brakeman](https://github.com/presidentbeef/brakeman) Run `brakeman -I` to generate `config/brakeman.ignore`

## Impersonation

The `rails_api_base` incorporates a user impersonation feature, allowing `AdminUser`s to assume the identity of other `User`s. This feature is disabled by default.

See [Impersonation docs](./docs/impersonation.md) for more info

## Monitoring

In order to use [New Relic](https://newrelic.com) to monitor your application requests and metrics, you must setup `NEW_RELIC_API_KEY` and `NEW_RELIC_APP_NAME` environment variables.
To obtain an API key you must create an account in the platform.

## Configuring Code Climate

1. After adding the project to CC, go to `Repo Settings`
1. On the `Test Coverage` tab, copy the `Test Reporter ID`
1. Set the current value of `CC_TEST_REPORTER_ID` in the [GitHub secrets and variables](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository)

## Code Owners

You can use [CODEOWNERS](https://help.github.com/en/articles/about-code-owners) file to define individuals or teams that are responsible for code in the repository.

Code owners are automatically requested for review when someone opens a pull request that modifies code that they own.

## Credits

Rails API Base is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our
[contributors](https://github.com/rootstrap/rails_api_base/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
