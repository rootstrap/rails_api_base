---
name: rails-conventions
description: Rootstrap Rails conventions. Use when writing, reviewing, or editing any Rails code — controllers, models, migrations, routes, views, mailers, initializers, locale files, or Rails config. Covers routing, ActiveRecord, migrations, i18n, time zones, mailers, assets, Bundler groups, and logging.
---

# Rails Conventions (Rootstrap)

Apply these whenever producing or modifying Rails-specific code. Full guide: https://github.com/rootstrap/tech-guides/blob/master/ruby/rails.md

Complements `ruby-conventions` (language-level style still applies).

## Configuration
- Custom initialization in `config/initializers`; one file per gem, named after the gem (e.g. `carrierwave.rb`).
- Environment-specific settings in `config/environments/`; shared settings in `config/application.rb`.
- Create a `staging` environment that mirrors production.
- Extra YAML config under `config/`, loaded via `Rails::Application.config_for(:yaml_file)`.
- Append non-default assets to `config.assets.precompile` in `production.rb` (e.g. admin CSS/JS). `application.*` and non-JS/CSS assets are already included.

## Routing
- Prefer `resources` over custom routes; use `:only`/`:except` to limit routes.
  ```ruby
  # bad
  get 'topics/:id', to: 'topics#show'
  # good
  resources :topics, only: :show
  ```
- `member`/`collection` for extra RESTful actions; use block form when many.
- Express associations with nested routes; use `shallow: true` beyond 1 level deep.
- `namespace` to group related actions (e.g. `admin`).
- Never use the wildcard `match ':controller(/:action(/:id(.:format)))'` route.
- Avoid `match` unless mapping multiple HTTP verbs via `:via`.

## Controllers
- Keep controllers skinny — no business logic (belongs in models/services).
- Each action should ideally call only one method beyond an initial `find`/`new`.
- Share at most two instance variables between controller and view.

## Rendering
- Prefer templates/partials over `render inline:`.
- `render plain:` over `render text:`.
- Use HTTP status symbols, not numbers.
  ```ruby
  # bad
  render status: 500
  # good
  render status: :forbidden
  ```

## Models
- Introduce non-ActiveRecord model classes freely; short, meaningful names.
- Use ActiveAttr gem for non-persisted models needing AR-like behavior.
- Keep models for business logic/persistence; move formatting/HTML concerns to decorators.

## ActiveRecord
- Don't alter AR defaults (table names, primary keys) without strong reason.
- Group macros at top in order: `default_scope`, constants, `attr_*`, `enum`, associations, validations, callbacks, other macros (e.g. devise).
- Prefer `has_many :through` over `has_and_belongs_to_many`.
- Prefer `self[:attr]` / `self[:attr] = value` over `read_attribute`/`write_attribute`.
- Use "sexy" validation syntax:
  ```ruby
  validates :email, presence: true, length: { maximum: 100 }
  ```
- Extract reused/regex validators into `app/validators` as `EachValidator` subclasses. If the validator is generic and used across multiple apps, extract it to a shared gem instead.
- Use named scopes; convert complex parameterized scopes into class methods returning a relation.
- Beware validation-skipping methods: `update_attribute`, `update_columns`, `update_all`, `increment!`, `toggle`, `touch`, counter methods.
- User-friendly URLs: override `to_param` or use `friendly_id`.
  ```ruby
  def to_param
    "#{id} #{name}".parameterize
  end
  ```
- Use `find_each` for iterating AR collections, not `all.each`.
- Always add `prepend: true` on `before_destroy` callbacks that perform validation.
- Always set `dependent:` on `has_many`/`has_one`.
- When persisting, use bang methods (`save!`, `create!`, `update!`) or handle the returned status.

## ActiveRecord Queries
- **Never interpolate params into SQL strings.** Use `?` placeholders or named placeholders (prefer named when >1).
- `find(id)` over `where(id: id).take`; `find_by(attrs)` for attribute-based single lookups.
- `where.not(id: id)` over `where("id != ?", id)`.
- Heredocs with `.squish` for explicit SQL in `find_by_sql`:
  ```ruby
  User.find_by_sql(<<-SQL.squish)
    SELECT ...
  SQL
  ```

## Migrations
- Keep `schema.rb` (or `structure.sql`) in version control; use `rake db:schema:load` for new DBs.
- Enforce defaults at the DB level, not the application.
- Enforce foreign-key constraints (Rails 4.2+).
- Use `change` for constructive migrations; use `up`/`down` for non-reversible ones like `drop_table` (or pass a block to `drop_table` inside `change`). `change` only works for commands listed in `ActiveRecord::Migration::CommandRecorder`.
- If using a model inside a migration, redefine it with an explicit `table_name`:
  ```ruby
  class MigrationProduct < ActiveRecord::Base
    self.table_name = :products
  end
  ```
- Name foreign keys explicitly (e.g. `name: :articles_author_id_fk`).
- Avoid `FLOAT` for rational numbers; use `DECIMAL` or a base-unit integer (money in cents).

## Views
- Never call models directly from views.
- Complex formatting → decorators.
- Use partials and layouts to deduplicate.

## Internationalization
- No user-facing strings in views/models/controllers; move to `config/locales`.
- `activerecord` scope for model/attribute translations (`User.model_name.human`, `human_attribute_name`).
- Organize locales into `locales/models` and `locales/views`; load extra dirs via `config.i18n.load_path`.
- Short forms `I18n.t` / `I18n.l`.
- Lazy lookup (`t '.title'`) in views; dot-separated keys elsewhere instead of `:scope`.

## Assets
- `app/assets` → app-specific.
- `lib/assets` → in-house libs.
- `vendor/assets` → third-party.
- Prefer gemified assets (e.g. `jquery-rails`, `bootstrap-sass`).

## Mailers
- Name classes `SomethingMailer`; provide both HTML and plain-text templates.
- `config.action_mailer.raise_delivery_errors = true` in development.
- Local SMTP (Mailcatcher/Letter Opener) in development.
- Set `default_url_options[:host]` per environment.
- Always use `_url` helpers (not `_path`) in email bodies.
- Format `default from:` as `'Your Name <info@your_site.com>'`.
- Test env: `delivery_method = :test`; dev/prod: `:smtp`.
- Inline CSS for HTML emails (use `premailer-rails` or `roadie`).
- Send emails in background jobs (e.g. Sidekiq); never inline during request.

## Active Support Core Extensions
- Prefer `&.` over `try!`.
- Prefer stdlib (`start_with?`, `end_with?`, `include?`) over AS aliases (`starts_with?`, `in?`).
- Prefer plain comparisons over `inquiry`, `Numeric#positive?`/`negative?`, etc.

## Time
- Set `config.time_zone` in `application.rb`.
- **Never use `Time.parse` or `Time.now`.** Use `Time.zone.parse`, `Time.zone.now`, or `Time.current`.

## Bundler
- Dev/test gems in proper Gemfile groups.
- Prefer well-established gems; review source of obscure ones.
- Group OS-specific gems under `darwin` / `linux` and use `Bundler.require(platform)`.
- **Never remove `Gemfile.lock` from version control.**

## Managing Processes
- Use `foreman` to manage multiple external processes (see `Procfile` / `Procfile.dev`).

## Logging
- Pass a block to `Rails.logger.debug` when interpolating to avoid string-building at suppressed levels.
  ```ruby
  # good
  Rails.logger.debug { "attrs: #{@person.attributes.inspect}" }
  ```
