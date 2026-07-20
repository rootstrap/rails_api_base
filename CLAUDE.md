# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Rootstrap's Rails API template — a Rails 8.1 / Ruby 4.0 boilerplate for JSON APIs. It is meant to be cloned and renamed via `bin/bootstrap.sh --name=<project>`, which `sed`s `rails_api_base` to your project name across the codebase. The template ships with two parallel surfaces:

- A JSON API under `/api/v1/*` (devise_token_auth, Pundit, Jbuilder, OpenAPI docs).
- An admin web surface built on ActiveAdmin at `/admin/*`, with sub-mounts for Flipper (`/admin/feature-flags`) and GoodJob (`/admin/background-jobs`).

## Common commands

The `bin/*` wrappers transparently dispatch to Docker (`docker compose`) when `DOCKER_ENABLED=true` in `.env`, otherwise run locally. Use them rather than calling `bundle`/`rails`/`rspec` directly so the same invocation works in both modes.

- `bin/dev` — start Rails + JS/CSS bundling watchers (foreman / `Procfile.dev`). Defaults to port 3000.
- `bin/rspec [path]` — run specs. `bin/rspec .` runs everything. `bin/rspec spec/path/to_spec.rb:42` runs a single example. Pass `-rm` / `--remove-containers` to tear down docker test services after the run.
- `bin/rails …` — any Rails command (`bin/rails console`, `bin/rails db:migrate`, …).
- `bin/bundle …` — bundler commands.
- `bin/web <cmd>` — arbitrary shell command inside the app container/environment.
- `bundle exec rails code:analysis` — runs the full lint suite: Brakeman, RuboCop, Reek, rails_best_practices, i18n-tasks (see `lib/tasks/code_analysis.rake`). Use this before opening a PR.
- `bundle exec annotaterb models` — refresh schema annotations on models (config in `.annotaterb.yml`).
- `yarn build:js --watch` / `yarn build:css --watch` — JS/CSS bundling for ActiveAdmin assets (already wired into `bin/dev`).

### Testing notes

- Specs require a running Postgres (see `docker-compose.yml` / `docker-compose.test.yml`). `.env.test` provides test DB config.
- `bin/rspec` headed by default; set `HEADLESS=true` for headless feature specs.
- `spec/rails_helper.rb` wires several behaviors that affect how to write specs:
  - **Prosopite scans every example for N+1 queries** — fix the query, don't silence it.
  - **rspec-retry** retries failed examples (2x in CI via `ENV['CI']`, 1x locally). Don't paper over flakes by adding retries.
  - **SimpleCov** is started before Rails loads; coverage lands in `coverage/`.
  - **Flipper** resets to a memory adapter before each test, so feature-flag state is per-example. Enable in a `before` block.
  - Files under `spec/forms/` are auto-tagged `type: :form` and get Shoulda matchers.
  - Files under `spec/requests/api/` are picked up by `rspec-openapi` for API doc generation; other request specs are tagged `openapi: false`.
- OpenAPI doc generation is triggered by `OPENAPI=1` (CI only on `main` / changes to `spec/requests/api/**`). Docs are served at `/api-docs` (basic auth: `SWAGGER_USERNAME` / `SWAGGER_PASSWORD`).

## Architecture

### Controllers: two distinct base classes

- `ApplicationController` (in `app/controllers/application_controller.rb`) — inherits `ActionController::Base`, used for the web/admin surface. Pundit `verify_authorized` / `verify_policy_scoped` are enforced *except* for Devise and ActiveAdmin controllers.
- `API::V1::APIController` (in `app/controllers/api/v1/api_controller.rb`) — inherits `ActionController::API`, the base for every JSON endpoint under `/api/v1`. It pulls in `DeviseTokenAuth::Concerns::SetUserByToken`, requires auth via `authenticate_user!`, enforces Pundit on every action, and centralises JSON error rendering: `RecordNotFound` → 404, `RecordInvalid` → 400, `ParameterMissing` → 422. New API controllers should inherit from this and rely on those rescues — don't re-implement error responses.

When adding an API endpoint, the wiring is: route under `namespace :api { namespace :v1 }` in `config/routes.rb` → controller under `app/controllers/api/v1/` inheriting `API::V1::APIController` → policy under `app/policies/` (or one is auto-resolved) → Jbuilder view under `app/views/api/v1/`. Strict loading is on by default (`config/application.rb`), so preload associations or expect log warnings.

### Auth

- API: `devise_token_auth` mounted at `/api/v1/users` with custom controllers (`registrations`, `sessions`, `passwords`) under `app/controllers/api/v1/`.
- Admin: standard Devise for `AdminUser`, then ActiveAdmin.
- Impersonation: admins can act as users via `POST /api/v1/impersonations` — gated behind `Impersonation::EnabledConstraint` (off by default). Object logic lives under `app/objects/impersonation/`. See `docs/impersonation.md`.

### Authorization

Pundit policies under `app/policies/`. `application_policy.rb` is the base. Admin-area policies live under `app/policies/admin/`. Because both base controllers enforce `verify_authorized` / `verify_policy_scoped`, every non-Devise/AA action must call `authorize` or `policy_scope`, or it will raise in tests.

### Models, decorators, forms, objects

- `app/models/` — ActiveRecord. Keep formatting out.
- `app/services/` Business logic
- `app/decorators/` — Draper decorators for view/serialization formatting.
- `app/forms/` — YAAF form objects (base: `ApplicationForm`). Use these for multi-model or multi-step writes instead of fat controllers.
- `app/objects/` — service-like POROs (e.g. `app/objects/impersonation/`).
- `app/components/` — view components (ActiveAdmin / Flipper UI).

### Feature flags (Flipper)

- Register flags in `config/feature-flags.yml` (a YAML list with `name:` / `description:`).
- A release-time rake task (`feature_flags.rake`) syncs the YAML to the DB-backed Flipper adapter in non-test environments.
- Test env uses the in-memory adapter and resets between examples (`Flipper.instance = nil` in the `before` hook), so just call `Flipper.enable(:my_flag)` in `before`.
- See `docs/feature_flags.md`.

### Background jobs

GoodJob, queue `mailers` for ActionMailer (see `config/application.rb`). The GoodJob dashboard mounts at `/admin/background-jobs` (admin auth required).

## Conventions

Three project-level Claude Code skills live under `.claude/skills/` and auto-activate based on the files being edited:

- `ruby-conventions` — any `*.rb` / Gemfile / Rakefile.
- `rails-conventions` — Rails-specific code (controllers, models, migrations, routes, mailers, initializers, locales, config).
- `rspec-conventions` — anything under `spec/`.

They encode Rootstrap's [tech-guides](https://github.com/rootstrap/tech-guides/tree/master/ruby). **Read the relevant skill before editing** — it's the source of truth for style decisions on this repo. Highlights worth keeping in mind even before they trigger:

- Never use `Time.now` / `Time.parse` — use `Time.current` / `Time.zone.parse`.
- Use bang persistence methods (`save!`, `create!`, `update!`) or handle the boolean result.
- HTTP statuses as symbols (`:forbidden`), not numbers.
- User-facing strings belong in `config/locales/`, not inline.
- Prefer `find_each` over `.all.each`.

## PR workflow

`.claude/rules/github-pr-formatting.md` is the single source of truth for PRs (referenced by `.claude/commands/create-pr.md`). Before opening a PR:

1. Run the `pr-size-checker` agent (target: ≤ ~400 added lines per PR).
2. Read `.github/PULL_REQUEST_TEMPLATE.md` and fill **every** section (Board, Description, Notes, Tasks, Risk, Preview) — use `* N/A` rather than skipping.
3. Title format: `[TICKET-ID] Description` if there's a ticket, plain description otherwise (dependency bumps, hotfixes). Under 70 chars.

## Things to double-check before committing

- New API endpoint? Confirm it has a spec under `spec/requests/api/` (it'll be picked up by the OpenAPI generator).
- New model association? Set `dependent:` on `has_many` / `has_one`.
- New migration? Strong Migrations runs in dev — if it complains, follow its remediation, don't bypass.
- New gem? Put it in the right Gemfile group (dev/test gems out of the runtime group).
- Touching N+1-sensitive code? Run the affected specs locally; Prosopite will fail the example if you introduce one.
