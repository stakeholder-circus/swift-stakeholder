import Foundation

enum DevelopmentType: String, CaseIterable, Codable {
    case backend
    case frontend
    case fullstack
    case dataScience = "data-science"
    case devOps = "dev-ops"
    case blockchain
    case machineLearning = "machine-learning"
    case systemsProgramming = "systems-programming"
    case gameDevelopment = "game-development"
    case security
}

enum JargonLevel: String, CaseIterable, Codable {
    case low
    case medium
    case high
    case extreme
}

enum Complexity: String, CaseIterable, Codable {
    case low
    case medium
    case high
    case extreme
}

enum OutputFormat: String, CaseIterable, Codable {
    case text
    case json
}

struct FamilySpec {
    let cliValue: String
    let title: String
    let protocolName: String?
    let group: String
}

let familySpecs: [FamilySpec] = [
    FamilySpec(cliValue: "code-analyzer", title: "Code analyzer", protocolName: nil, group: "classic-six"),
    FamilySpec(cliValue: "data-processing", title: "Data processing", protocolName: nil, group: "classic-six"),
    FamilySpec(cliValue: "jargon", title: "Jargon refresh", protocolName: nil, group: "classic-six"),
    FamilySpec(cliValue: "metrics", title: "Metrics", protocolName: nil, group: "classic-six"),
    FamilySpec(cliValue: "network-activity", title: "Network activity", protocolName: "grpc", group: "classic-six"),
    FamilySpec(cliValue: "system-monitoring", title: "System monitoring", protocolName: nil, group: "classic-six"),
    FamilySpec(cliValue: "agent-workflows", title: "Agent workflows", protocolName: "mcp", group: "modern-core"),
    FamilySpec(cliValue: "ai-inference-ops", title: "AI inference ops", protocolName: "responses-api", group: "ai-governance"),
    FamilySpec(cliValue: "platform-engineering", title: "Platform engineering", protocolName: nil, group: "modern-core"),
    FamilySpec(cliValue: "supply-chain-security", title: "Supply-chain security", protocolName: nil, group: "modern-core"),
    FamilySpec(cliValue: "observability-ai-runtime", title: "Observability AI runtime", protocolName: nil, group: "modern-core"),
    FamilySpec(cliValue: "delivery-preview-ops", title: "Delivery preview ops", protocolName: nil, group: "modern-core"),
    FamilySpec(cliValue: "evaluation-and-guardrails", title: "Evaluation and guardrails", protocolName: "responses-api", group: "ai-governance"),
    FamilySpec(cliValue: "knowledge-retrieval", title: "Knowledge retrieval", protocolName: "responses-api", group: "ai-governance"),
    FamilySpec(cliValue: "edge-client-runtime", title: "Edge client runtime", protocolName: "webtransport", group: "health-protocol"),
    FamilySpec(cliValue: "identity-and-trust", title: "Identity and trust", protocolName: nil, group: "security-blockchain"),
    FamilySpec(cliValue: "aibom-provenance", title: "AIBOM provenance", protocolName: nil, group: "ai-governance"),
    FamilySpec(cliValue: "agent-boundary-security", title: "Agent boundary security", protocolName: "mcp", group: "security-blockchain"),
    FamilySpec(cliValue: "embedded-agentic-pipeline", title: "Embedded agentic pipeline", protocolName: nil, group: "health-protocol"),
    FamilySpec(cliValue: "data-governance-compliance", title: "Data governance compliance", protocolName: nil, group: "ai-governance"),
    FamilySpec(cliValue: "finops-capacity", title: "FinOps capacity", protocolName: nil, group: "ai-governance"),
    FamilySpec(cliValue: "blockchain-protocol-ops", title: "Blockchain protocol ops", protocolName: nil, group: "security-blockchain"),
    FamilySpec(cliValue: "cross-chain-interop", title: "Cross-chain interop", protocolName: nil, group: "security-blockchain"),
    FamilySpec(cliValue: "proof-and-sequencer-ops", title: "Proof and sequencer ops", protocolName: nil, group: "security-blockchain"),
    FamilySpec(cliValue: "hybrid-runtime-ops", title: "Hybrid runtime ops", protocolName: nil, group: "overlay-quantum"),
    FamilySpec(cliValue: "capacity-cost-controller", title: "Capacity and cost controller", protocolName: nil, group: "overlay-quantum"),
    FamilySpec(cliValue: "batch-execution-tuner", title: "Batch execution tuner", protocolName: nil, group: "overlay-quantum"),
    FamilySpec(cliValue: "compiler-maintainer", title: "Compiler maintainer", protocolName: "openqasm3", group: "overlay-quantum"),
    FamilySpec(cliValue: "interop-adapter-engineer", title: "Interop adapter engineer", protocolName: "qir", group: "overlay-quantum"),
    FamilySpec(cliValue: "preflight-capacity-planner", title: "Preflight capacity planner", protocolName: nil, group: "overlay-quantum"),
    FamilySpec(cliValue: "simulator-performance-engineer", title: "Simulator performance engineer", protocolName: "openqasm3", group: "overlay-quantum"),
    FamilySpec(cliValue: "fhir-profile-generator", title: "FHIR profile generator", protocolName: "fhir-r4", group: "health-protocol"),
    FamilySpec(cliValue: "smart-launch-oauth", title: "SMART launch OAuth", protocolName: "smart-launch", group: "health-protocol"),
    FamilySpec(cliValue: "bulk-fhir-population-ops", title: "Bulk FHIR population ops", protocolName: "bulk-fhir", group: "health-protocol"),
    FamilySpec(cliValue: "hl7v2-feed-ops", title: "HL7 v2 feed ops", protocolName: "hl7v2", group: "health-protocol"),
    FamilySpec(cliValue: "clinical-workflow-events", title: "Clinical workflow events", protocolName: "fhir-r4", group: "health-protocol"),
    FamilySpec(cliValue: "dicomweb-imaging-ops", title: "DICOMweb imaging ops", protocolName: "dicomweb", group: "health-protocol"),
    FamilySpec(cliValue: "openehr-semantic-record-ops", title: "openEHR semantic record ops", protocolName: "openehr", group: "health-protocol"),
    FamilySpec(cliValue: "device-telemetry-clinical", title: "Device telemetry clinical", protocolName: "ihe-device", group: "health-protocol"),
    FamilySpec(cliValue: "emr-vendor-adapter", title: "EMR vendor adapter", protocolName: "epic-fhir", group: "health-protocol"),
    FamilySpec(cliValue: "ocpp-chargepoint-ops", title: "OCPP chargepoint ops", protocolName: "ocpp-2.x", group: "health-protocol"),
    FamilySpec(cliValue: "ocpi-roaming-ops", title: "OCPI roaming ops", protocolName: "ocpi-2.x", group: "health-protocol"),
    FamilySpec(cliValue: "mcp-a2a-ops", title: "MCP and A2A ops", protocolName: "mcp", group: "health-protocol"),
    FamilySpec(cliValue: "streaming-bus-ops", title: "Streaming bus ops", protocolName: "kafka", group: "health-protocol"),
    FamilySpec(cliValue: "service-mesh-rpc-ops", title: "Service mesh RPC ops", protocolName: "grpc", group: "health-protocol"),
    FamilySpec(cliValue: "multilingual-security-packs", title: "Multilingual security packs", protocolName: nil, group: "overlay-quantum"),
    FamilySpec(cliValue: "security-persona-packs", title: "Security persona packs", protocolName: nil, group: "overlay-quantum")
]

let familyByCLI = Dictionary(uniqueKeysWithValues: familySpecs.map { ($0.cliValue, $0) })
let classicFamilies = ["code-analyzer", "data-processing", "jargon", "metrics", "network-activity", "system-monitoring"]
let policyFamilies = ["supply-chain-security", "observability-ai-runtime", "evaluation-and-guardrails", "identity-and-trust", "aibom-provenance", "agent-boundary-security", "data-governance-compliance", "finops-capacity"]
let alertFamilies = ["supply-chain-security", "observability-ai-runtime", "agent-boundary-security", "device-telemetry-clinical", "ocpp-chargepoint-ops", "streaming-bus-ops", "service-mesh-rpc-ops", "mcp-a2a-ops"]
let teamFamilies = ["agent-workflows", "platform-engineering", "delivery-preview-ops", "service-mesh-rpc-ops"]
let securityFamilies = ["supply-chain-security", "agent-boundary-security", "identity-and-trust", "aibom-provenance", "data-governance-compliance", "mcp-a2a-ops", "blockchain-protocol-ops", "cross-chain-interop", "proof-and-sequencer-ops", "multilingual-security-packs", "security-persona-packs"]
let experimentalProviders = ["openai-compatible", "anthropic", "openai-consumer", "claude-consumer"]
let experimentalAdapterModes = ["api", "consumer"]
let multilingualSecurity = ["english", "chinese", "russian", "spanish", "arabic"]
let securityPersonas = ["bug-bounty-operator", "incident-commander", "reverse-engineer", "threat-hunter", "soc-analyst", "dark-market-watcher", "cti-brief-writer"]
let supportedFlags = ["alerts", "minimal", "team", "seed", "output-format", "no-color", "trace", "list-values", "experimental-provider", "experimental-model", "experimental-profile", "experimental-prompt", "experimental-adapter-mode"]

func listValuesPayload() -> [String: Any] {
    let devTypes = DevelopmentType.allCases.map(\.rawValue)
    let jargonLevels = JargonLevel.allCases.map(\.rawValue)
    let complexities = Complexity.allCases.map(\.rawValue)
    let outputFormats = OutputFormat.allCases.map(\.rawValue)
    return [
        "devType": devTypes,
        "devTypes": devTypes,
        "jargon": jargonLevels,
        "jargonLevels": jargonLevels,
        "complexity": complexities,
        "complexities": complexities,
        "outputFormat": outputFormats,
        "outputFormats": outputFormats,
        "generatorFamilies": familySpecs.map(\.cliValue),
        "experimentalProviders": experimentalProviders,
        "experimentalAdapterModes": experimentalAdapterModes,
        "flags": supportedFlags,
    ]
}
