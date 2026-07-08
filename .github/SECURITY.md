# Security Policy

## Supported versions

`prayer_time_plus` is pre-1.0; fixes land on the latest `0.x` release.

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Reporting a vulnerability

**Please do not report security vulnerabilities through public issues, pull
requests, or discussions.**

Report privately using GitHub's
[**Report a vulnerability**](https://github.com/abdulwahed-s/prayer_time_plus/security/advisories/new)
button on the repository's **Security** tab. This opens a private advisory that
only you and the maintainer can see.

Please include:

- the affected version(s) and platform,
- a description of the issue and its impact,
- steps or a minimal example that reproduces it,
- any suggested fix, if you have one.

You can expect an acknowledgement within a few days. Once confirmed, a fix will
be prepared and released and the advisory published, crediting the reporter
unless you prefer to remain anonymous.

## Scope

This is an offline library with no network, file, or process access and no
runtime dependencies — it takes coordinates, a date, and a UTC offset and returns
times. Most reports will concern incorrect results (use the bug template for
those) rather than exploitable behaviour, but genuine memory-safety,
denial-of-service (for example inputs that hang the computation), or
supply-chain concerns are in scope and welcome.
