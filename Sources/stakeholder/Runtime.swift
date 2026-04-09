import Foundation

struct ActivitySelection {
    let family: String
    let flavors: [String]
    let kind: String
}

struct RenderedActivity {
    let message: String
    let metadata: [String: String]
}

struct NormalizedEvent: Codable, Equatable {
    let eventType: String
    let sequence: Int
    let message: String
    let timestamp: String
    let context: [String: String]
}

struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

let dedicatedFamilies: Set<String> = [
    "code-analyzer",
    "data-processing",
    "jargon",
    "metrics",
    "network-activity",
    "system-monitoring",
    "agent-workflows",
]

let dedicatedRendererDetails: [String: (group: String, focusKey: String, focusValue: String)] = [
    "code-analyzer": (
        group: "classic-six",
        focusKey: "analysisFocus",
        focusValue: "typed interfaces, agent-authored patches, and MCP assumptions"
    ),
    "data-processing": (
        group: "classic-six",
        focusKey: "dataWindow",
        focusValue: "embeddings, semantic chunks, and batch transforms with deterministic ordering"
    ),
    "jargon": (
        group: "classic-six",
        focusKey: "languagePolicy",
        focusValue: "credible 2026 terminology instead of fake-deep phrasing"
    ),
    "metrics": (
        group: "classic-six",
        focusKey: "signalBlend",
        focusValue: "queue depth, token spend, and GPU occupancy in a single operations lane"
    ),
    "network-activity": (
        group: "classic-six",
        focusKey: "transportMix",
        focusValue: "RPC, event-stream, and adapter traffic under deterministic retry rules"
    ),
    "system-monitoring": (
        group: "classic-six",
        focusKey: "telemetryScope",
        focusValue: "collector pressure, runner health, and policy-denial signals across the stack"
    ),
    "agent-workflows": (
        group: "modern-core",
        focusKey: "coordinationMode",
        focusValue: "delegated agent work, approval gates, and cross-repo handoff envelopes"
    ),
]

enum SessionRuntime {
    static func run(config: SessionConfig) -> [NormalizedEvent] {
        var generator = SeededGenerator(seed: stableSeed(config.seed))
        let plan = buildActivityPlan(config: config, generator: &generator)
        var events: [NormalizedEvent] = []
        var sequence = 0
        events.append(buildEvent(config: config, sequence: sequence, eventType: "session.start", message: "Session configuration accepted", context: [
            "project": config.projectName,
            "devType": config.devType.rawValue,
            "jargon": config.jargonLevel.rawValue,
            "complexity": config.complexity.rawValue,
            "framework": config.framework,
            "durationSeconds": String(config.durationSeconds),
        ]))
        sequence += 1
        events.append(buildEvent(config: config, sequence: sequence, eventType: "boot.sequence", message: "Scheduler baseline initialized", context: [
            "plannedActivities": String(plannedActivities(config.complexity)),
            "alertsEnabled": String(config.alertsEnabled),
            "teamActivity": String(config.teamActivity),
            "seeded": String(config.seed != nil),
            "outputFormat": config.outputFormat.rawValue,
        ]))
        sequence += 1
        for selection in plan {
            let rendered = renderSelection(selection: selection, config: config)
            var context: [String: String] = [
                "family": selection.family,
                "kind": selection.kind,
                "protocol": familyByCLI[selection.family]?.protocolName ?? "",
                "flavors": selection.flavors.joined(separator: ","),
                "project": config.projectName,
            ]
            rendered.metadata.forEach { context[$0.key] = $0.value }
            if !config.framework.isEmpty {
                context["framework"] = config.framework
            }
            events.append(buildEvent(config: config, sequence: sequence, eventType: "activity", message: rendered.message, context: context))
            sequence += 1
            if config.trace {
                events.append(buildEvent(config: config, sequence: sequence, eventType: "trace", message: traceLine(selection: selection), context: [
                    "family": selection.family,
                    "protocol": familyByCLI[selection.family]?.protocolName ?? "",
                    "flavorCount": String(selection.flavors.count),
                ]))
                sequence += 1
            }
        }
        events.append(buildEvent(config: config, sequence: sequence, eventType: "session.end", message: "Session completed", context: [
            "exitCode": "0",
            "result": "ok",
            "plannedActivities": String(plan.count),
        ]))
        return events
    }

    static func textLines(config: SessionConfig) -> [String] {
        var lines = run(config: config)
            .filter { $0.eventType == "activity" || $0.eventType == "trace" }
            .map { event in
                if event.eventType == "trace" {
                    return "trace: \(event.message)"
                }
                let title = familyByCLI[event.context["family", default: ""]]?.title ?? "Activity"
                return "[\(title)] \(event.message)"
            }
        lines.append("session terminated (deterministic-pass)")
        return lines
    }

    private static func buildActivityPlan(config: SessionConfig, generator: inout SeededGenerator) -> [ActivitySelection] {
        let targetCount = plannedActivities(config.complexity)
        let eligible = eligibleFamilies(config: config)
        var selected: [String] = []
        pushUnique(selected: &selected, eligible: eligible, pool: classicFamilies, generator: &generator)
        if targetCount >= 2 {
            let modern = eligible.filter { !classicFamilies.contains($0) && $0 != "jargon" }
            pushUnique(selected: &selected, eligible: modern, pool: modern, generator: &generator)
        }
        if targetCount >= 3 {
            pushUnique(selected: &selected, eligible: eligible, pool: policyFamilies, generator: &generator)
        }
        while selected.count < targetCount {
            let choice = pick(eligible, generator: &generator)
            if !selected.contains(choice) { selected.append(choice) }
        }
        if config.alertsEnabled { pushUnique(selected: &selected, eligible: eligible, pool: alertFamilies, generator: &generator) }
        if config.teamActivity { pushUnique(selected: &selected, eligible: eligible, pool: teamFamilies, generator: &generator) }
        return selected.map { family in
            ActivitySelection(
                family: family,
                flavors: resolveFlavors(config: config, family: family, generator: &generator),
                kind: config.alertsEnabled && alertFamilies.contains(family) ? "alert-injection" : (config.teamActivity && teamFamilies.contains(family) ? "team-injection" : "generator")
            )
        }
    }

    private static func eligibleFamilies(config: SessionConfig) -> [String] {
        var selected = Set(classicFamilies)
        switch config.devType {
        case .backend:
            selected.formUnion(["agent-workflows", "ai-inference-ops", "platform-engineering", "supply-chain-security", "observability-ai-runtime", "delivery-preview-ops", "evaluation-and-guardrails", "knowledge-retrieval", "identity-and-trust", "aibom-provenance", "data-governance-compliance", "finops-capacity", "mcp-a2a-ops", "streaming-bus-ops", "service-mesh-rpc-ops"])
        case .frontend:
            selected.formUnion(["agent-workflows", "delivery-preview-ops", "edge-client-runtime", "observability-ai-runtime", "knowledge-retrieval", "service-mesh-rpc-ops"])
        case .fullstack:
            selected.formUnion(["agent-workflows", "ai-inference-ops", "platform-engineering", "observability-ai-runtime", "delivery-preview-ops", "knowledge-retrieval", "mcp-a2a-ops", "streaming-bus-ops", "service-mesh-rpc-ops", "supply-chain-security"])
        case .dataScience:
            selected.formUnion(["ai-inference-ops", "knowledge-retrieval", "evaluation-and-guardrails", "aibom-provenance", "data-governance-compliance", "observability-ai-runtime"])
        case .devOps:
            selected.formUnion(["agent-workflows", "platform-engineering", "supply-chain-security", "observability-ai-runtime", "delivery-preview-ops", "identity-and-trust", "finops-capacity", "mcp-a2a-ops", "streaming-bus-ops", "service-mesh-rpc-ops"])
        case .blockchain:
            selected.formUnion(["blockchain-protocol-ops", "cross-chain-interop", "proof-and-sequencer-ops", "supply-chain-security", "identity-and-trust", "mcp-a2a-ops"])
        case .machineLearning:
            selected.formUnion(["ai-inference-ops", "knowledge-retrieval", "evaluation-and-guardrails", "observability-ai-runtime", "aibom-provenance", "finops-capacity"])
        case .systemsProgramming:
            selected.formUnion(["observability-ai-runtime", "embedded-agentic-pipeline", "identity-and-trust", "supply-chain-security", "streaming-bus-ops"])
        case .gameDevelopment:
            selected.formUnion(["edge-client-runtime", "delivery-preview-ops", "observability-ai-runtime", "streaming-bus-ops", "service-mesh-rpc-ops"])
        case .security:
            selected.formUnion(["agent-workflows", "supply-chain-security", "observability-ai-runtime", "evaluation-and-guardrails", "identity-and-trust", "aibom-provenance", "agent-boundary-security", "data-governance-compliance", "mcp-a2a-ops", "streaming-bus-ops", "service-mesh-rpc-ops"])
        }
        let context = "\(config.projectName) \(config.framework)".lowercased()
        if containsKeyword(context, ["ehr", "emr", "fhir", "hl7", "openehr", "dicom", "clinical", "patient", "hospital"]) {
            selected.formUnion(["fhir-profile-generator", "smart-launch-oauth", "bulk-fhir-population-ops", "hl7v2-feed-ops", "clinical-workflow-events", "dicomweb-imaging-ops", "openehr-semantic-record-ops", "device-telemetry-clinical", "emr-vendor-adapter"])
        }
        if containsKeyword(context, ["charge", "charger", "charging", "ev", "ocpp", "ocpi", "roaming"]) {
            selected.formUnion(["ocpp-chargepoint-ops", "ocpi-roaming-ops", "streaming-bus-ops", "service-mesh-rpc-ops"])
        }
        if containsKeyword(context, ["quantum", "qir", "qasm", "braket", "qiskit", "cudaq", "ionq"]) {
            selected.formUnion(["hybrid-runtime-ops", "capacity-cost-controller", "batch-execution-tuner", "compiler-maintainer", "interop-adapter-engineer", "preflight-capacity-planner", "simulator-performance-engineer"])
        }
        if containsKeyword(context, ["mcp", "a2a", "mqtt", "nats", "kafka", "grpc", "graphql", "webtransport"]) {
            selected.formUnion(["mcp-a2a-ops", "streaming-bus-ops", "service-mesh-rpc-ops"])
        }
        return familySpecs.map(\.cliValue).filter { selected.contains($0) }
    }

    private static func resolveFlavors(config: SessionConfig, family: String, generator: inout SeededGenerator) -> [String] {
        var flavors: [String] = []
        if config.devType == .security || securityFamilies.contains(family) {
            if config.jargonLevel == .high || config.jargonLevel == .extreme || config.alertsEnabled {
                flavors.append("multilingual-security:\(pick(multilingualSecurity, generator: &generator))")
            }
            if config.jargonLevel == .high || config.jargonLevel == .extreme {
                flavors.append("security-persona:\(pick(securityPersonas, generator: &generator))")
            }
        }
        let context = "\(config.projectName) \(config.framework)".lowercased()
        if containsKeyword(context, ["experimental", "openai", "anthropic", "claude", "responses", "llm"]) && ["ai-inference-ops", "evaluation-and-guardrails", "aibom-provenance"].contains(family) {
            flavors.append("experimental-live-provider")
        }
        return flavors
    }

    private static func renderSelection(selection: ActivitySelection, config: SessionConfig) -> RenderedActivity {
        let spec = familyByCLI[selection.family]!
        if dedicatedFamilies.contains(selection.family) {
            return renderDedicatedActivity(selection: selection, config: config)
        }
        return RenderedActivity(message: "\(spec.title.lowercased()) lane for \(config.projectName): \(fallbackDetail(spec: spec, jargon: config.jargonLevel))", metadata: ["rendererGroup": spec.group, "familyMode": "grouped-fallback", "protocolAware": spec.protocolName == nil ? "false" : "true"])
    }

    static func renderDedicatedActivity(selection: ActivitySelection, config: SessionConfig) -> RenderedActivity {
        let spec = familyByCLI[selection.family]!
        let details = dedicatedRendererDetails[selection.family]!
        let detail = dedicatedDetail(family: selection.family, jargon: config.jargonLevel)
        var metadata: [String: String] = [
            "rendererGroup": details.group,
            "familyMode": "dedicated",
            "familyFocusKey": details.focusKey,
            details.focusKey: details.focusValue,
            "smokeEvidence": "true",
            "traceabilitySourceRepo": "rust-stakeholder",
            "traceabilitySourcePath": "Sources/stakeholder/Runtime.swift",
            "traceabilityContractRepo": "stakeholder-core",
            "traceabilityContractPath": "docs/generator-families.md",
            "traceabilityParityClass": "depth",
        ]
        if selection.family == "agent-workflows" {
            metadata["controlPlane"] = spec.cliValue
        } else {
            metadata["discipline"] = spec.cliValue
        }
        return RenderedActivity(
            message: "\(spec.title.lowercased()) depth pass for \(config.projectName): \(detail) Traceability is anchored to Rust and stakeholder-core.",
            metadata: metadata
        )
    }

    private static func fallbackDetail(spec: FamilySpec, jargon: JargonLevel) -> String {
        let detail: String
        switch spec.group {
        case "classic-six":
            detail = "keeping the baseline scheduler deterministic while the shared registry handles the legacy engineering lanes"
        case "modern-core":
            detail = "coordinating 2026-first control-plane work under the shared registry and deterministic activity planner"
        case "ai-governance":
            detail = "tracking retrieval, evaluation, provenance, and governance checkpoints without widening the parity contract"
        case "security-blockchain":
            detail = "holding trust, sequencing, and boundary controls steady under deterministic replay"
        case "health-protocol":
            detail = "covering protocol-aware operations through grouped fallback until dedicated family ports land"
        case "overlay-quantum":
            detail = "holding overlay and quantum operations on grouped fallback while preserving the expanded registry surface"
        default:
            detail = "running through the shared deterministic fallback renderer"
        }
        if (jargon == .high || jargon == .extreme), let protocolName = spec.protocolName {
            return "\(detail) with protocol focus on \(protocolName)"
        }
        return detail
    }
}

func dedicatedDetail(family: String, jargon: JargonLevel) -> String {
    let details: [String: [JargonLevel: String]] = [
        "code-analyzer": [
            .low: "reviewing typed interfaces and generated-client drift across the active service graph",
            .medium: "reviewing typed interfaces and generated-client drift across the active service graph",
            .high: "triaging monorepo dependency edges, schema mismatches, and SDK drift before merge",
            .extreme: "replaying agent-authored patchsets against contract drift, ownership boundaries, and tool assumptions",
        ],
        "data-processing": [
            .low: "rebuilding embeddings, semantic chunks, and batch transforms with deterministic ordering",
            .medium: "rebuilding embeddings, semantic chunks, and batch transforms with deterministic ordering",
            .high: "reconciling retrieval indexes, backfills, and multimodal data cuts for downstream consumers",
            .extreme: "stitching lakehouse slices, evaluation-ready datasets, and replay-safe transforms into one data lane",
        ],
        "jargon": [
            .low: "keeping technical language current without drifting into fake-deep jargon",
            .medium: "keeping technical language current without drifting into fake-deep jargon",
            .high: "switching phrasing toward credible 2026 agent, platform, protocol, and security terminology",
            .extreme: "enforcing modern domain vocabulary so advanced output stays precise instead of sounding synthetic",
        ],
        "metrics": [
            .low: "tracking queue depth, latency bands, and cost signals across the active workload",
            .medium: "tracking queue depth, latency bands, and cost signals across the active workload",
            .high: "correlating token spend, SLO burn, GPU occupancy, and attestation coverage in one metrics lane",
            .extreme: "folding evaluation score movement, blob economics, and runner pressure into a single operations dashboard",
        ],
        "network-activity": [
            .low: "observing RPC, event-stream, and adapter traffic across the current service boundary",
            .medium: "observing RPC, event-stream, and adapter traffic across the current service boundary",
            .high: "mapping MCP calls, inference APIs, registry fetches, and cross-domain message flow under backpressure",
            .extreme: "profiling mixed gRPC, Kafka, MQTT, and bridge traffic while preserving replay semantics and retry windows",
        ],
        "system-monitoring": [
            .low: "watching collector pressure, runner health, and process saturation on the active stack",
            .medium: "watching collector pressure, runner health, and process saturation on the active stack",
            .high: "capturing GPU memory pressure, secret-scan spikes, sandbox failures, and scheduler queue churn",
            .extreme: "stitching host telemetry, proof queues, provisioning lag, and policy denials into one operational heartbeat",
        ],
        "agent-workflows": [
            .low: "routing coding-agent work through review queues and approval gates",
            .medium: "routing coding-agent work through review queues and approval gates",
            .high: "coordinating delegated patch runs, blocked tool calls, and human checkpoints across multiple repos",
            .extreme: "orchestrating branch handoff envelopes, MCP leases, and merge-safe approval chains for background agents",
        ],
    ]
    return details[family]?[jargon] ?? "running through the shared deterministic fallback renderer"
}

func plannedActivities(_ complexity: Complexity) -> Int {
    switch complexity {
    case .low: return 1
    case .medium: return 2
    case .high: return 3
    case .extreme: return 4
    }
}

func buildEvent(config: SessionConfig, sequence: Int, eventType: String, message: String, context: [String: String]) -> NormalizedEvent {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    let baseDate = config.seed == nil ? Date() : Date(timeIntervalSince1970: 0)
    let timestamp = formatter.string(from: baseDate.addingTimeInterval(TimeInterval(sequence)))
    return NormalizedEvent(eventType: eventType, sequence: sequence, message: message, timestamp: timestamp, context: context)
}

func traceLine(selection: ActivitySelection) -> String {
    let protocolName = familyByCLI[selection.family]?.protocolName ?? ""
    let suffix = protocolName.isEmpty ? "" : " protocol=\(protocolName)"
    return "scheduled \(selection.family) kind=\(selection.kind) flavorCount=\(selection.flavors.count)\(suffix)"
}

func stableSeed(_ value: String?) -> UInt64 {
    guard let value else { return 0xC0FFEE }
    if let number = UInt64(value) { return number }
    var hash: UInt64 = 1469598103934665603
    for byte in value.utf8 {
        hash ^= UInt64(byte)
        hash = hash &* 1099511628211
    }
    return hash
}

func pick<T>(_ values: [T], generator: inout SeededGenerator) -> T {
    values[Int(generator.next() % UInt64(values.count))]
}

func pushUnique(selected: inout [String], eligible: [String], pool: [String], generator: inout SeededGenerator) {
    let candidates = pool.filter { eligible.contains($0) && !selected.contains($0) }
    if !candidates.isEmpty {
        selected.append(pick(candidates, generator: &generator))
    }
}

func containsKeyword(_ haystack: String, _ needles: [String]) -> Bool {
    needles.contains { haystack.contains($0) }
}

func encodeEvents(_ events: [NormalizedEvent]) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    let data = try! encoder.encode(events)
    return String(decoding: data, as: UTF8.self)
}
