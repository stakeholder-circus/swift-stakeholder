# Docker

The repo uses the official Swift 5.10 image for build and test.

## Commands
- `docker build -t swift-stakeholder .`
- `docker run --rm swift-stakeholder --list-values`

## CI intent
- Build and test in the container image.
- Smoke the contract surface with `--list-values`.
