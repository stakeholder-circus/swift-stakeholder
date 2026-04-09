import Foundation

struct SessionConfig {
    var devType: DevelopmentType = .backend
    var jargonLevel: JargonLevel = .medium
    var complexity: Complexity = .medium
    var durationSeconds: Int = 0
    var alertsEnabled = false
    var projectName = "distributed-cluster"
    var minimalOutput = false
    var teamActivity = false
    var framework = ""
    var seed: String?
    var outputFormat: OutputFormat = .text
    var noColor = false
    var trace = false
    var experimentalProvider: String?
    var experimentalModel: String?
    var experimentalProfile: String?
    var experimentalPrompt: String?
    var experimentalAdapterMode: String?
}

struct RunResult {
    let exitCode: Int32
    let stdout: String
    let stderr: String
}

enum CLIError: Error {
    case missingValue(String)
    case invalidValue(String, String)

    var message: String {
        switch self {
        case let .missingValue(flag):
            return "missing value for \(flag)"
        case let .invalidValue(flag, value):
            return "invalid value '\(value)' for \(flag)"
        }
    }
}

enum StakeholderCLI {
    static func run(arguments: [String]) -> RunResult {
        do {
            let config = try parse(arguments: arguments)
            if arguments.contains("--list-values") {
                return RunResult(exitCode: 0, stdout: encodeJSONObject(listValuesPayload()) + "\n", stderr: "")
            }
            if hasExperimentalInput(config) {
                return RunResult(
                    exitCode: 2,
                    stdout: "",
                    stderr: "experimental provider runtime is not implemented in swift-stakeholder; use javascript-stakeholder for provider-backed runs\n"
                )
            }
            if config.outputFormat == .json {
                return RunResult(exitCode: 0, stdout: encodeEvents(SessionRuntime.run(config: config)) + "\n", stderr: "")
            }
            return RunResult(exitCode: 0, stdout: SessionRuntime.textLines(config: config).joined(separator: "\n") + "\n", stderr: "")
        } catch let error as CLIError {
            return RunResult(exitCode: 2, stdout: "", stderr: error.message + "\n")
        } catch {
            return RunResult(exitCode: 2, stdout: "", stderr: String(describing: error) + "\n")
        }
    }

    private static func parse(arguments: [String]) throws -> SessionConfig {
        var config = SessionConfig()
        var index = 0
        while index < arguments.count {
            let argument = arguments[index]
            switch argument {
            case "--list-values", "--alerts", "--minimal", "--team", "--no-color", "--trace":
                if argument == "--alerts" { config.alertsEnabled = true }
                if argument == "--minimal" { config.minimalOutput = true }
                if argument == "--team" { config.teamActivity = true }
                if argument == "--no-color" { config.noColor = true }
                if argument == "--trace" { config.trace = true }
                index += 1
            case "--dev-type":
                config.devType = try parseEnum(flag: argument, value: try consumeValue(after: &index, in: arguments), as: DevelopmentType.self)
            case "--jargon":
                config.jargonLevel = try parseEnum(flag: argument, value: try consumeValue(after: &index, in: arguments), as: JargonLevel.self)
            case "--complexity":
                config.complexity = try parseEnum(flag: argument, value: try consumeValue(after: &index, in: arguments), as: Complexity.self)
            case "--duration":
                let raw = try consumeValue(after: &index, in: arguments)
                guard let value = Int(raw) else { throw CLIError.invalidValue(argument, raw) }
                config.durationSeconds = value
            case "--project":
                config.projectName = try consumeValue(after: &index, in: arguments)
            case "--framework":
                config.framework = try consumeValue(after: &index, in: arguments)
            case "--seed":
                config.seed = try consumeValue(after: &index, in: arguments)
            case "--output-format":
                config.outputFormat = try parseEnum(flag: argument, value: try consumeValue(after: &index, in: arguments), as: OutputFormat.self)
            case "--experimental-provider":
                config.experimentalProvider = try consumeValue(after: &index, in: arguments)
            case "--experimental-model":
                config.experimentalModel = try consumeValue(after: &index, in: arguments)
            case "--experimental-profile":
                config.experimentalProfile = try consumeValue(after: &index, in: arguments)
            case "--experimental-prompt":
                config.experimentalPrompt = try consumeValue(after: &index, in: arguments)
            case "--experimental-adapter-mode":
                config.experimentalAdapterMode = try consumeValue(after: &index, in: arguments)
            default:
                throw CLIError.invalidValue("argument", argument)
            }
        }
        return config
    }

    private static func consumeValue(after index: inout Int, in arguments: [String]) throws -> String {
        let next = index + 1
        guard next < arguments.count else { throw CLIError.missingValue(arguments[index]) }
        index = next + 1
        return arguments[next]
    }

    private static func parseEnum<T: RawRepresentable>(flag: String, value: String, as: T.Type) throws -> T where T.RawValue == String {
        guard let parsed = T(rawValue: value) else {
            throw CLIError.invalidValue(flag, value)
        }
        return parsed
    }

    private static func hasExperimentalInput(_ config: SessionConfig) -> Bool {
        [config.experimentalProvider, config.experimentalModel, config.experimentalProfile, config.experimentalPrompt, config.experimentalAdapterMode]
            .contains { $0 != nil }
    }
}

func encodeJSONObject(_ payload: [String: Any]) -> String {
    let data = try! JSONSerialization.data(withJSONObject: payload, options: [.sortedKeys])
    return String(decoding: data, as: UTF8.self)
}
