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

    func testDedicatedClassicSixAndAgentWorkflowsRenderersEmitFamilySpecificMetadata() throws {
        let config = SessionConfig(jargonLevel: .high, projectName: "depth-tranche")
        let cases: [(String, String, String, String, String)] = [
            ("code-analyzer", "classic-six", "analysisFocus", "typed interfaces, agent-authored patches, and MCP assumptions", "triaging monorepo dependency edges"),
            ("data-processing", "classic-six", "dataWindow", "embeddings, semantic chunks, and batch transforms with deterministic ordering", "reconciling retrieval indexes"),
            ("jargon", "classic-six", "languagePolicy", "credible 2026 terminology instead of fake-deep phrasing", "switching phrasing toward credible 2026 agent"),
            ("metrics", "classic-six", "signalBlend", "queue depth, token spend, and GPU occupancy in a single operations lane", "correlating token spend"),
            ("network-activity", "classic-six", "transportMix", "RPC, event-stream, and adapter traffic under deterministic retry rules", "mapping MCP calls"),
            ("system-monitoring", "classic-six", "telemetryScope", "collector pressure, runner health, and policy-denial signals across the stack", "capturing GPU memory pressure"),
            ("agent-workflows", "modern-core", "coordinationMode", "delegated agent work, approval gates, and cross-repo handoff envelopes", "coordinating delegated patch runs"),
        ]
        for (family, rendererGroup, focusKey, focusValue, detailFragment) in cases {
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
            XCTAssertEqual(rendered.metadata["traceabilityContractRepo"], "stakeholder-core")
            XCTAssertEqual(rendered.metadata["traceabilityContractPath"], "docs/generator-families.md")
            XCTAssertEqual(rendered.metadata["traceabilityParityClass"], "depth")
            XCTAssertEqual(rendered.metadata["smokeEvidence"], "true")
            XCTAssertTrue(rendered.message.contains(detailFragment))
            XCTAssertTrue(rendered.message.contains("Traceability is anchored to Rust and stakeholder-core."))
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
