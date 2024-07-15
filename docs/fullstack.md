# Fullstack
## Context
The `rails_api_base` was originally created to be used as a backend API, but it evolved to be more than just that, and now it is also intended to be used for Rails Fullstack apps.

## Stack
The chosen stack is:
- [Hotwire](https://hotwired.dev) as the frontend framework, including [Turbo](https://turbo.hotwired.dev) and [Stimulus](https://stimulus.hotwired.dev).
- [Tailwind](https://tailwindcss.com) as the CSS framework.
- [ViewComponent](https://viewcomponent.org) as the components framework, along with  [Lookbook](https://lookbook.build) for a beautiful dev UI environment.

## Setup
In order to setup the `rails_api_base` for fullstack development, run
```bash
bin/rails app:template LOCATION=./bin/fullstack.rb
```
in the root of the project and it will automatically install and configure everything you need.

## Setup with Docker
If you want to use Docker and also want the example component to be created, you'll need to run this command so the RSpec test passes.
```bash
docker compose -f docker-compose.test.yml run --build web ./bin/rails app:template LOCATION=./bin/fullstack.rb
```
