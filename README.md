> [!IMPORTANT]
> This repository is part of a Codex-assisted rewrite experiment. All changes are manually reviewed, a human remains in the loop, and missing behavior is tracked explicitly rather than hidden. The project exists for fun, research, language learning, AI agent workflow/planning, interop experiments, and code review testing.
# swift-stakeholder

Swift widened classic-six follower for the stakeholder rewrite.

## Implemented surface
- Typed config model and full 2026+ family registry.
- Seeded deterministic scheduler.
- Registry-based renderer dispatch.
- Dedicated renderer depth for:
  - `code-analyzer`
  - `data-processing`
  - `jargon`
  - `metrics`
  - `network-activity`
  - `system-monitoring`
  - `agent-workflows`
- Grouped fallback renderers for the remaining families.
- Normalized JSON event output.
- Explicit fail-fast handling for experimental provider flags.

## Commands
- `swift build`
- `swift test`
- `swift-format lint --recursive Sources Tests`
- `docker build -t swift-stakeholder .`
- `docker run --rm swift-stakeholder --list-values`
