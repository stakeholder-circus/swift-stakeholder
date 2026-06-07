import XCTest
@testable import stakeholder

final class stakeholderTests: XCTestCase {
    func testListValuesIncludesRegistry() throws {
        let result = StakeholderCLI.run(arguments: ["--list-values"])
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("code-analyzer"))
        XCTAssertTrue(result.stdout.contains("agent-workflows"))
    }

    func testDeterministicJSONIsStableForSameSeed() throws {
        let first = StakeholderCLI.run(arguments: ["--seed", "42", "--output-format", "json"])
        let second = StakeholderCLI.run(arguments: ["--seed", "42", "--output-format", "json"])
        XCTAssertEqual(first.exitCode, 0)
        XCTAssertEqual(first.stdout, second.stdout)
    }

    func testDedicatedClassicSixAndModernCoreRenderersEmitFamilySpecificMetadata() throws {
        let config = SessionConfig(jargonLevel: .high, projectName: "depth-tranche")
        let cases: [(String, String, String, String, String, String)] = [
            ("code-analyzer", "classic-six", "analysisFocus", "typed interfaces, agent-authored patches, and MCP assumptions", "triaging monorepo dependency edges", "src/main/java/com/stakeholder/generators/CodeAnalyzerRenderer.java"),
            ("data-processing", "classic-six", "dataWindow", "embeddings, semantic chunks, and batch transforms with deterministic ordering", "reconciling retrieval indexes", "src/main/java/com/stakeholder/generators/DataProcessingRenderer.java"),
            ("jargon", "classic-six", "languagePolicy", "credible 2026 terminology instead of fake-deep phrasing", "switching phrasing toward credible 2026 agent", "src/main/java/com/stakeholder/generators/JargonRenderer.java"),
            ("metrics", "classic-six", "signalBlend", "queue depth, token spend, and GPU occupancy in a single operations lane", "correlating token spend", "src/main/java/com/stakeholder/generators/MetricsRenderer.java"),
            ("network-activity", "classic-six", "transportMix", "RPC, event-stream, and adapter traffic under deterministic retry rules", "mapping MCP calls", "src/main/java/com/stakeholder/generators/NetworkActivityRenderer.java"),
            ("system-monitoring", "classic-six", "telemetryScope", "collector pressure, runner health, and policy-denial signals across the stack", "capturing GPU memory pressure", "src/main/java/com/stakeholder/generators/SystemMonitoringRenderer.java"),
            ("agent-workflows", "modern-core", "coordinationMode", "delegated agent work, approval gates, and cross-repo handoff envelopes", "coordinating delegated patch runs", "src/main/java/com/stakeholder/generators/AgentWorkflowsRenderer.java"),
            ("platform-engineering", "modern-core", "platformSurface", "golden paths, identity boundaries, and queue ownership in the shared platform lane", "lining up golden paths, identity federation, queue ownership, and paved-road rollouts", "src/main/java/com/stakeholder/generators/PlatformEngineeringRenderer.java"),
            ("observability-ai-runtime", "modern-core", "runtimeSignals", "trace spans, token burn, GPU pressure, and policy denials in one runtime lane", "correlating inference spans, token burn, GPU saturation, and sandbox denials", "src/main/java/com/stakeholder/generators/ObservabilityAIRuntimeRenderer.java"),
            ("delivery-preview-ops", "modern-core", "deliveryGuardrail", "preview deploys, canaries, release flags, and rollback checkpoints under seed control", "coordinating preview deploys, canary health, release flags, and rollback checkpoints", "src/main/java/com/stakeholder/generators/DeliveryPreviewOpsRenderer.java"),
            ("supply-chain-security", "modern-core", "supplyChainPosture", "provenance, attestations, dependency drift, and secret exposure in one security lane", "linking attestations, dependency drift, key rotation, and registry trust signals", "src/main/java/com/stakeholder/generators/SupplyChainSecurityRenderer.java"),
        ]
        for (family, rendererGroup, focusKey, focusValue, detailFragment, javaPath) in cases {
            let rendered = SessionRuntime.renderDedicatedActivity(
                selection: ActivitySelection(family: family, flavors: [], kind: "generator"),
                config: config
            )
            XCTAssertEqual(rendered.metadata["rendererGroup"], rendererGroup)
            XCTAssertEqual(rendered.metadata["familyMode"], "dedicated")
            XCTAssertEqual(rendered.metadata["familyFocusKey"], focusKey)
            XCTAssertEqual(rendered.metadata[focusKey], focusValue)
            XCTAssertEqual(rendered.metadata["traceabilitySourceRepo"], "rust-stakeholder")
            XCTAssertEqual(rendered.metadata["traceabilitySourcePath"], "Sources/stakeholder/Runtime.swift")
            XCTAssertEqual(rendered.metadata["traceabilityJavaRepo"], "java-stakeholder")
            XCTAssertEqual(rendered.metadata["traceabilityJavaPath"], javaPath)
            XCTAssertEqual(rendered.metadata["traceabilityContractRepo"], "stakeholder-core")
            XCTAssertEqual(rendered.metadata["traceabilityContractPath"], "docs/generator-families.md")
            XCTAssertEqual(rendered.metadata["traceabilityParityClass"], "depth")
            XCTAssertEqual(rendered.metadata["smokeEvidence"], "true")
            XCTAssertTrue(rendered.message.contains(detailFragment))
            XCTAssertTrue(rendered.message.contains("Traceability is anchored to Java, Rust, and stakeholder-core."))
        }
    }

    func testDedicatedSmokeFamiliesAppear() throws {
        let config = SessionConfig(jargonLevel: .high, projectName: "depth-tranche")
        let codeAnalyzer = SessionRuntime.renderDedicatedActivity(
            selection: ActivitySelection(family: "code-analyzer", flavors: [], kind: "generator"),
            config: config
        )
        let agentWorkflows = SessionRuntime.renderDedicatedActivity(
            selection: ActivitySelection(family: "agent-workflows", flavors: [], kind: "generator"),
            config: config
        )
        XCTAssertTrue(codeAnalyzer.message.contains("code analyzer depth pass"))
        XCTAssertEqual(codeAnalyzer.metadata["familyMode"], "dedicated")
        XCTAssertTrue(agentWorkflows.message.contains("agent workflows depth pass"))
        XCTAssertEqual(agentWorkflows.metadata["familyMode"], "dedicated")
    }

    func testExperimentalFlagsFailFast() throws {
        let result = StakeholderCLI.run(arguments: ["--experimental-provider", "openai-compatible"])
        XCTAssertEqual(result.exitCode, 2)
        XCTAssertTrue(result.stderr.contains("not implemented"))
    }
}
