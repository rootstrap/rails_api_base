---
name: ruby-conventions
description: Rootstrap Ruby style conventions. Use when writing, reviewing, or editing any Ruby source file (*.rb, *.rake, Gemfile, Rakefile, *.gemspec, config.ru) to ensure code follows the Rootstrap Ruby style guide — covers layout, syntax, naming, classes/modules, exceptions, collections, strings, regexes, metaprogramming, and general best practices.
---

# Ruby Conventions (Rootstrap)

Apply these conventions whenever producing or modifying Ruby code. Full guide: https://github.com/rootstrap/tech-guides/blob/master/ruby/README.md

Most of these are enforced by RuboCop (see `.rubocop.yml`). When in doubt, run RuboCop.

## Source Code Layout
- UTF-8, Unix line endings, 2-space indentation (no tabs), one expression per line (no `;`).
- Max 100 chars per line; end files with a newline; no trailing whitespace.
- Prefer `FooError = Class.new(StandardError)` over empty `class ... end`.
- Avoid single-line methods (exception: `def no_op; end`).
- Spaces around operators, after commas/colons; no spaces inside `(`, `[`, around `!`, or in range literals (`1..3`).
- Exception: no spaces around exponent: `c**2`.
- Indent `when` the same as `case`.
- Blank lines between methods and around access modifiers; no blank lines inside class/method bodies.
- No trailing comma after last arg/element.
- Spaces around `=` in default params: `def f(a = 1)`.
- Avoid line continuation `\` except for string concatenation.
- In multi-line chains, keep `.` on the next line.
- Use underscores in big numbers: `1_000_000`. Lowercase prefixes `0x`, `0o`, `0b`.
- No block comments (`=begin`/`=end`).
- Never more than one consecutive blank line.
- Align multi-line method args after `(`, OR single-indent with `)` on its own line (avoid "double indent").
- For `case`/`if` result assignment, either align branches under the keyword or break with `kind =` on its own line.

## Syntax
- Use `::` only for constants/constructors, not method calls.
- `def` with parens when params exist, omit when empty.
- Parens around method arguments, except: no-arg calls, DSL methods (`validates :name, ...`), and keyword-like (`attr_reader`, `puts`).
- Optional args at end of parameter list.
- Prefix unused block vars with `_`: `|_k, v|`.
- Avoid parallel assignment (`a, b, c = 1, 2, 3`) except for swap, method-return destructuring, or splat.
- Prefer trailing-underscore form: `a, = foo.split(',')` over `a, _, _ = ...`. Use named underscore vars (`_second`) when position conveys meaning.
- Don't use `for`; use iterators (`each`).
- No `then` in multi-line `if`; no `if x; ...`. Always put the condition on the same line as `if`/`unless`.
- Avoid multi-line ternary — use `if`/`unless` instead.
- No `while cond do` / `until cond do` for multi-line loops (drop the `do`).
- Favor ternary over `if/then/else` one-liners; don't nest ternaries.
- Leverage `if`/`case` as expressions.
- Use `!` not `not`; avoid `!!` boolean coercion.
- **`and`/`or` keywords are banned** — use `&&`/`||`.
- Favor modifier `if`/`unless`/`while`/`until` for single-line bodies; avoid on multi-line blocks; don't nest modifiers.
- Favor `unless` for negatives; favor `until` over `while` for negative loop conditions. **Never `unless` with `else`**.
- No parens around control-expression conditions (except safe assignment `if (v = ...)`).
- Use `Kernel#loop` for infinite loops; prefer `loop { ... break unless ... }` over `begin ... end while` for post-condition loops.
- Omit outer `{}` AND parens for internal DSL methods: `validates :name, presence: true, length: { within: 1..10 }`.
- Omit outer `{}` on trailing options hashes: `user.set(name: 'John', age: 45)`.
- Use `&:method` shorthand: `names.map(&:upcase)`.
- `{...}` for single-line blocks, `do...end` for multi-line. Avoid `do...end` in chains.
- Avoid explicit `return` when unnecessary; avoid `self.` unless required.
- Use `||=` to init nil/unset vars; don't use `||=` for booleans.
- Use `&&=` to preprocess nullable values.
- Avoid `===` outside `case`.
- Use `==` not `eql?` unless strict type comparison is intended.
- No space between method name and opening paren: `f(x)`.
- No nested method defs; use lambdas.
- Lambda: `->(a, b) { ... }` with args (parens required); `-> { ... }` with no args (omit parens); `lambda do ... end` for multi-line.
- Prefer `proc` over `Proc.new`; use `.call()` not `[]` or `.()`.
- Use shorthand self-assignment: `x += y`, `x **= y`, etc.
- Use explicit `&block` to forward blocks rather than wrapping them.
- Don't shadow methods with local variables (e.g. naming an arg `options` when an accessor already exists).
- Don't use character literals (`?x`) — use `'x'`.
- Avoid Perl-style special vars (`$;`, `$,`); prefer `English` library aliases (`$LOAD_PATH`, etc.).
- Don't use `BEGIN`/`END` blocks; use `Kernel#at_exit` instead.
- Use `warn` over `$stderr.puts`.
- Favor `sprintf`/`format` over `String#%`; `Array#join` over `Array#*`.
- Use `Array(var)` to coerce possibly-single values into arrays.
- Use ranges or `between?` instead of `x >= a && x <= b`.
- Predicate methods (`.even?`, `.zero?`, `.nil?`) over `== 0`, `== nil`.
- Avoid `!x.nil?` when `if x` suffices.
- Guard clauses over nested conditionals; `next` over `if` in loops.
- Prefer: `map` over `collect`, `select` over `find_all`, `find` over `detect`, `reduce` over `inject`, `size` over `length`/`count` (note: `count` on non-Array Enumerables iterates the full collection).
- `flat_map` over `map.flatten(1)`; `reverse_each` over `reverse.each`.

## Naming
- Identifiers in English, `snake_case` for methods/vars/symbols/files/dirs.
- `CamelCase` for classes/modules; keep acronyms uppercase (`XMLParser`).
- `SCREAMING_SNAKE_CASE` for constants.
- Predicate methods end with `?`; **do not prefix** with `is_`/`can_`/`does_`.
- Bang methods (`!`) exist only when a safe counterpart exists.
- Name binary operator params `other` (exceptions: `<<` and `[]`).
- No numeric separation: `some_var1` not `some_var_1`.
- One class/module per file, file named `snake_case` after the class/module.
- Define non-bang methods in terms of bang when possible: `def flatten_once; dup.flatten_once!; end`.

## Comments
- Prefer self-documenting code; comments in English, capitalized, one space after `#`.
- Refactor bad code instead of explaining it.
- Avoid superfluous comments (`counter += 1 # Increments counter by one`).
- Keep comments up to date — an outdated comment is worse than none.
- Annotations: `TODO`, `FIXME`, `OPTIMIZE`, `HACK`, `REVIEW` + `:` + description, above the relevant code. Document custom annotation keywords in the project README.
- Magic comments (`# frozen_string_literal: true`) at top, one per line, blank line before code.

## Classes & Modules
- Layout order: `extend`/`include` → inner classes → constants → `attr_*` → other macros → public class methods → `initialize` → public instance methods → protected → private.
- Separate `include` per mixin.
- Don't nest multi-line classes; use matching folder structure.
- Prefer modules (`extend self`) over classes with only class methods.
- Use `def self.method` (not `def ClassName.method`).
- Within class methods calling siblings, omit `self.`.
- Always supply `to_s` for domain objects.
- Use `attr_reader`/`attr_accessor`; avoid `attr`; don't prefix with `get_`/`set_`.
- `Struct.new` for trivial value objects; don't inherit from it.
- Avoid class variables (`@@var`); prefer class instance variables.
- Proper visibility (`private`/`protected`); indent modifiers at method level with blank lines.
- Prefer duck-typing over inheritance.
- Apply SOLID principles; respect the Liskov Substitution Principle (subclasses should be substitutable for their parents).
- Encourage factory methods for clearer object creation APIs.
- Use `alias` in lexical scope; `alias_method` for runtime/module aliasing. Note: `alias` binds at definition time, so subclass overrides won't be picked up unless re-aliased.

## Exceptions
- Prefer `raise` over `fail`; `raise SomeException, 'message'` (not `.new(...)`, not `RuntimeError`).
- Never `return` from `ensure`.
- Use implicit `begin` in method bodies (`def foo ... rescue ... end`).
- Don't suppress exceptions; avoid `rescue` in modifier form.
- No exceptions for flow control.
- **Never `rescue Exception`** — use `rescue StandardError => e` or bare `rescue => e`.
- Specific exceptions higher in the rescue chain.
- Release resources in `ensure` or block form (`File.open('f') { |f| ... }`).
- Favor stdlib exceptions over new classes.
- Extract repeated rescue patterns into contingency methods (`with_io_error_handling { ... }`) to DRY up error handling.

## Collections
- Use literals `[]` and `{}` (not `Array.new`, `Hash.new`).
- `%w[one two three]` for word arrays, `%i[a b c]` for symbol arrays (2+ elements).
- Prefer `first`/`last` over `[0]`/`[-1]`; `Set` for unique collections.
- Symbols as hash keys; 1.9 syntax `{ one: 1 }`; don't mix with hash rockets.
- `Hash#key?` not `has_key?`; `Hash#each_key` not `keys.each`.
- `Hash#fetch` for required keys; block form for expensive defaults: `hash.fetch(:k) { expensive }`.
- `Hash#values_at` for multi-key lookup.
- Don't mutate a collection while iterating.
- Don't use mutable objects as hash keys.
- Rely on ordered hashes (Ruby 1.9+); insertion order is preserved.
- When providing collection-returning APIs, offer an alternate accessor to avoid `nil[]`: prefer `Regexp.last_match(1)` over `Regexp.last_match[1]`.

## Numbers
- `Integer` (not `Fixnum`/`Bignum`) for type checks.
- `rand(1..6)` over `rand(6) + 1`.

## Strings
- Interpolation `"#{x}"` over concatenation.
- Pick single or double quotes consistently (guide prefers single when no interpolation).
- `{}` around `@var`/`$var` in interpolation; don't call `.to_s` inside.
- `String#<<` to build large strings, not `+=`.
- `sub`/`tr` over `gsub` when simpler.
- Squiggly heredocs `<<~END` for multi-line indented strings.

## Date & Time
- `Time.now` over `Time.new`; use `Date` or `Time`, not `DateTime`.
- (See also `rails-conventions` — in Rails, use `Time.zone.now`/`Time.current`.)

## Regular Expressions
- Plain string ops (`string['text']`) over regex when possible; also `string[/regexp/]` and `string[/text(grp)/, 1]` forms.
- `(?:...)` for non-capturing; named groups `(?<name>...)` over numbered.
- `Regexp.last_match(n)` not `$1`.
- `\A` / `\z` (not `^`/`$`) for full-string boundaries.
- `/x` modifier for complex, commented regexes.
- In character classes `[]`, only `^`, `-`, `\`, `]` need escaping; don't escape `.` or brackets.
- Use `sub`/`gsub` with a block or hash for complex replacements.

## Percent Literals
- `%()` only for single-line strings needing both interpolation and `"`. Heredocs for multi-line.
- Avoid `%q()` unless the string has both `'` and `"`.
- `%r{...}` only when the regex contains `/`.
- Brackets: `()` for strings, `[]` for `%w`/`%i`, `{}` for `%r`.
- Avoid `%x` unless invoking a command whose string contains backticks.
- Avoid `%s` — prefer `:"some string"` for symbols needing spaces.

## Metaprogramming
- Avoid needless metaprogramming; don't monkey-patch core classes in libraries.
- Prefer block `class_eval` over string form; prefer `define_method`.
- If you must use string-form `class_eval`/`eval`, pass `__FILE__` and `__LINE__` for sensible backtraces.
- Avoid `method_missing`; if needed, also define `respond_to_missing?`, call `super`, and only catch well-defined prefixes (e.g. `find_by_*`) — delegating to non-magical methods.
- `public_send` over `send`; `__send__` over `send` when receiver may define `send`.

## Misc
- Write `ruby -w` clean code (run with warnings).
- Avoid hashes as optional params (except initializers).
- Keep methods small (~10 LOC, ideally <5); params 3–4 max.
- Avoid more than 3 levels of block nesting.
- Code functionally; don't mutate parameters unless that's the method's purpose.
- Prefer module instance variables over globals (`$foo`).
- Use `OptionParser` for complex CLI options; `ruby -s` only for trivial cases.
- If adding global methods, put them in `Kernel` and make them `private`.
- Be consistent and use common sense — within a file, prefer matching the surrounding style over strict rule-following.
