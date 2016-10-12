# API Template

## Setup

1. Clone this repo
2. Create your `database.yml` and `application.yml` file
3. Generate a secret key with `rake secret` and paste this value into the `application.yml`
4. `bundle install`
5. `rake db:create`
6. `rake db:migrate`
7. [Optional] Set your [frontend URL](https://github.com/cyu/rack-cors#origin) in `config/initializers/rack_cors.rb`
8. Set your mail sender in `config/initializers/devise.rb`
9. `rails s`
