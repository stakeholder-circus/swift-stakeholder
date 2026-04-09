import Foundation

let result = StakeholderCLI.run(arguments: Array(CommandLine.arguments.dropFirst()))
if !result.stdout.isEmpty {
    fputs(result.stdout, stdout)
}
if !result.stderr.isEmpty {
    fputs(result.stderr, stderr)
}
exit(result.exitCode)
