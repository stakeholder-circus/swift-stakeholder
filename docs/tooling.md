# Tooling

## Standard commands
- `swift build`
- `swift test`
- `swift-format lint --recursive Sources Tests`
- `docker build -t swift-stakeholder .`
- `docker run --rm swift-stakeholder --list-values`

## Notes
- `swift-format` is the formatter/linter gate when the tool is available in the environment.
- The package stays dependency-light and uses the Swift Package Manager for build and test.
