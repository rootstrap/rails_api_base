---
name: rspec-conventions
description: Rootstrap RSpec conventions. Use when writing, reviewing, or editing RSpec test files (spec/**/*_spec.rb, spec/rails_helper.rb, spec/spec_helper.rb, spec/support/**/*.rb) or factories. Covers describe/context structure, let/subject, matchers, factories, mocking/stubbing, shared examples, and spec types (model, request, feature, controller).
---

# RSpec Conventions (Rootstrap)

Apply these whenever producing or modifying RSpec test code. Full guide: https://github.com/rootstrap/tech-guides/blob/master/ruby/rspec/style_guide.md

Complements `ruby-conventions` — language-level Ruby style still applies.

## Structure & Formatting
- No blank line directly after `describe`/`context`/`feature` opening.
- Leave one blank line after `let`/`subject` groups and after `before`/`after` blocks.
- Group `let` and `subject` together; separate them from `before`/`after` with a blank line.
- One blank line around each `it` block.
- Use `before` (not `before(:each)`); `before(:all)` should be rare and explicit.

## describe & context
- `describe '#method'` for instance methods, `describe '.method'` for class methods.
- `context` descriptions must start with `when` or `with`, forming a grammatical sentence.
  ```ruby
  context 'when the display name is not present'
  ```
- Every `context` should have a matching opposite/negative case — a lone context is a smell.
- Don't end `it` descriptions with a conditional ("...if X") — wrap in a `context` instead.

## it / Examples
- **Never start `it` with "should" / "should not".** State behavior directly.
  ```ruby
  it 'returns the summary'   # not: 'should return the summary'
  ```
- One expectation per `it` block (split multi-assertion examples).
- Avoid generating examples via iterators; use shared examples instead.
  ```ruby
  shared_examples 'responds successfully' do
    it 'returns 200' do ... end
  end
  it_behaves_like 'responds successfully'
  ```

## let & subject
- Prefer `let` over `before { @x = ... }` for test data (lazy, no instance vars).
- `let` is **lazy** (evaluated on first reference) and **cached within a single example, not across examples**. Use `let!` when you need eager evaluation before each example.
- Use `let` for values shared across several (not necessarily all) `it`s in a context; avoid overuse — it hurts readability.
- Use `subject` when describing a single primary object.
  ```ruby
  subject { create(:article) }
  ```

## Matchers
- Use RSpec magic matchers for predicate methods: `expect(subject).to be_published` (calls `published?`).
- Prefer `change` matchers over counting state before/after.
  ```ruby
  expect { article.publish }.to change(Article, :count).by(1)
  ```
- Avoid asserting incidental state (e.g. `Article.count == 2`) — test the delta or direct effect.

## Factories & Fixtures
- Use **FactoryBot** (`create(:article)`); **never** Rails fixtures.
- Avoid `ModelName.create` in integration specs — reach for the factory.
- Use **Faker** for fake data; **Database Cleaner** keeps state isolated.

## Mocking / Stubbing / Doubles
- Use mocks/stubs sparingly — favor them in isolated/behavioral specs, not integration specs.
- Only stub against small, stable, well-known APIs.
- **Never stub a method whose return you're asserting on** — produces false positives.
  ```ruby
  # Bad: stubs nil? itself
  allow(summary).to receive(:nil?).and_return(true)
  # Good: stub the upstream method, let the code run
  allow(subject).to receive(:summary).and_return(nil)
  ```
- Use **Webmock/VCR** for HTTP; never hit real APIs in tests.

## Time
- Use **Timecop** (`Timecop.freeze(Time.now) do ... end`) instead of stubbing `Time.now`/`Date.today`.

## Shared Examples
- Extract shared examples when duplication is real and clarifies intent — don't DRY prematurely.
- Duplication inside specs is acceptable, even preferred, if it aids readability.

## Spec Types (quick guidance)
- **Model/service/job/mailer specs** — unit tests of public methods and callbacks; don't test private methods.
- **Feature specs** — full UI flow via Capybara; only enable JS driver when required.
- **Controller specs** — for non-API controllers and edge cases faster than feature specs.
- **Request specs** (`type: :request`) — preferred over controller specs for APIs; exercises routes and real responses.
- Prefer `describe ... do` style over Capybara's `feature`/`scenario` DSL for consistency.
