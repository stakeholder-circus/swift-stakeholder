> [!IMPORTANT]
> This repository is part of a Codex-assisted rewrite experiment. All changes are manually reviewed, a human remains in the loop, and missing behavior is tracked explicitly rather than hidden. The project exists for fun, research, language learning, AI agent workflow/planning, interop experiments, and code review testing.
# swift-stakeholder

Swift is the current validated follower baseline through the modern-core wave for the stakeholder rewrite, with the live-provider lane still open for a later phase.

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
  - `platform-engineering`
  - `observability-ai-runtime`
  - `delivery-preview-ops`
  - `supply-chain-security`
- Grouped fallback renderers for the remaining families.
- Normalized JSON event output.
- Explicit fail-fast handling for experimental provider flags while the live-provider lane remains open.

## Commands
- `swift build`
- `swift test`
- `swift-format lint --recursive Sources Tests`
- `docker build -t swift-stakeholder .`
- `docker run --rm swift-stakeholder --list-values`
