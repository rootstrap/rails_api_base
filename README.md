# API Template

## Setup

1. Clone this repo
2. Create your `database.yml` and `application.yml` file
3. `bundle install`
4. Generate a secret key with `rake secret` and paste this value into the `application.yml`
5. `rake db:create`
6. `rake db:migrate`
7. `rails s`

## Optional configuration

- Set your [frontend URL](https://github.com/cyu/rack-cors#origin) in `config/initializers/rack_cors.rb`
- Set your mail sender in `config/initializers/devise.rb`
- Decrease `token_lifespan` in `config/initializers/devise_token_auth.rb` if the frontend is a Web-app.
- Remove Facebook code with `git revert a8319a37ab8d038399a7a6bd74fe3869bb3f3ddc`
- Config your timezone accordingly in `application.rb`.

## Docs

http://docs.rails5apibase.apiary.io
