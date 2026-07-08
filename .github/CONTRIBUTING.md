# Contributing to prayer_time_plus

Thanks for your interest in improving **prayer_time_plus** — the Dart / Flutter
port of an offline Islamic prayer-times engine. This guide covers how to set the
project up, the standards a change is held to, and how to get it merged.

The same engine also ships for
[Swift](https://github.com/abdulwahed-s/prayer-time-plus-swift) and
[Kotlin / JVM](https://github.com/abdulwahed-s/prayer-time-plus-kotlin). A change
that affects computed times should ideally be raised for all three ports so they
stay in lock-step.

## Ways to contribute

- **Report a bug** or an incorrect prayer time.
- **Request a feature** or a new calculation method.
- **Improve the docs** — the README, dartdoc comments, or the example.
- **Send a pull request** — see the workflow below.

Open issues from the [templates](https://github.com/abdulwahed-s/prayer_time_plus/issues/new/choose).
For anything security-related, **do not open a public issue** — follow
[SECURITY.md](SECURITY.md).

## Development setup

Requires the Dart SDK `>= 3.7`.

```bash
dart pub get                       # fetch dev dependencies
dart analyze                       # static analysis — must be clean
dart format .                      # formatting — must leave no changes
dart test                          # full test suite — must be green
dart test test/golden_test.dart    # the golden reference vectors
dart run prayer_time_plus          # CLI demo
```

Before a release, `dart pub publish --dry-run` must pass.

## Standards every change is held to

1. **Zero runtime dependencies.** The library depends only on the Dart SDK. Do
   not add a runtime dependency under `lib/`; `dev_dependencies` are fine.
2. **Numeric parity is sacred.** Prayer times are validated to the minute against
   a fixed set of golden vectors. A refactor must not change any computed time.
   If a change *should* alter output (a genuine fix), update the affected golden
   tests in the same PR and explain why in the description.
3. **Everything stays green.** `dart analyze`,
   `dart format --set-exit-if-changed .`, and `dart test` all pass. New
   behaviour comes with tests.
4. **Public API is documented.** Every public member has a `///` doc comment, and
   the main types carry a runnable example.

## Commit & PR conventions

- **[Conventional Commits](https://www.conventionalcommits.org/):**
  `type(scope): subject` in the imperative mood — e.g.
  `feat: add Singapore calculation method`, `fix: correct Isha rounding near DST`,
  `docs: clarify utcOffset handling`. Types: `feat`, `fix`, `test`, `docs`,
  `refactor`, `perf`, `chore`, `build`, `ci`.
- **Small, atomic commits** — one logical change each; the message describes only
  that change.
- Keep pull requests focused, fill in the template, and link the issue they
  close.

## Code of conduct

Be respectful and constructive. Harassment or abuse of any kind is not welcome in
issues, pull requests, or discussions.
