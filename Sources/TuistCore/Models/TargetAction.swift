import Foundation
import TSCBasic
import TuistSupport

/// It represents a target script build phase
public struct TargetAction: Equatable {
    /// Order when the action gets executed.
    ///
    /// - pre: Before the sources and resources build phase.
    /// - post: After the sources and resources build phase.
    public enum Order: String, Equatable {
        case pre
        case post
    }

    /// How to execute the target action
    ///
    /// - file: Executes the tool, calling the script at the path. Tuist will look up the tool on the environment's PATH
    /// - text: Executes the entered script. This should be a short command.
    private enum Script: Equatable {
        case file(_ tool: String?, _ path: AbsolutePath?, _ args: [String])
        case text(String)
    }

    /// Name of the build phase when the project gets generated
    public let name: String

    /// The script to execute in the action
    private let script: Script

    public var isEmbeddedScript: Bool {
        switch self.script {
        case .file:
            return false
        case .text:
            return true
        }
    }

    /// Name of the tool to execute.
    public var tool: String? {
        switch script {
        case .file(let tool, _, _):
            return tool
        case .text:
            return nil
        }
    }

    /// Path to the script to execute
    public var path: AbsolutePath? {
        switch script {
        case .file(_, let path, _):
            return path
        case .text:
            return nil
        }
    }

    /// Target action order
    public let order: Order

    /// Arguments that to be passed
    public var arguments: [String] {
        switch script {
        case .file(_, _, let args):
            return args
        case .text:
            return []
        }
    }

    /// List of input file paths
    public let inputPaths: [AbsolutePath]

    /// List of input filelist paths
    public let inputFileListPaths: [AbsolutePath]

    /// List of output file paths
    public let outputPaths: [AbsolutePath]

    /// List of output filelist paths
    public let outputFileListPaths: [AbsolutePath]

    /// Show environment variables in the logs
    public var showEnvVarsInLog: Bool

    /// Whether to skip running this script in incremental builds, if nothing has changed
    public let basedOnDependencyAnalysis: Bool?

    /// Initializes a new target action with its attributes.
    ///
    /// - Parameters:
    ///   - name: Name of the build phase when the project gets generated
    ///   - order: Target action order
    ///   - tool: Name of the tool to execute. Tuist will look up the tool on the environment's PATH
    ///   - path: Path to the script to execute
    ///   - arguments: Arguments that to be passed
    ///   - inputPaths: List of input file paths
    ///   - inputFileListPaths: List of input filelist paths
    ///   - outputPaths: List of output file paths
    ///   - outputFileListPaths: List of output filelist paths
    ///   - showEnvVarsInLog: Show environment variables in the logs
    ///   - basedOnDependencyAnalysis: Whether to skip running this script in incremental builds
    public init(name: String,
                order: Order,
                tool: String? = nil,
                path: AbsolutePath? = nil,
                arguments: [String] = [],
                inputPaths: [AbsolutePath] = [],
                inputFileListPaths: [AbsolutePath] = [],
                outputPaths: [AbsolutePath] = [],
                outputFileListPaths: [AbsolutePath] = [],
                showEnvVarsInLog: Bool = true,
                basedOnDependencyAnalysis: Bool? = nil)
    {
        self.name = name
        self.order = order
        self.script = .file(tool, path, arguments)
        self.inputPaths = inputPaths
        self.inputFileListPaths = inputFileListPaths
        self.outputPaths = outputPaths
        self.outputFileListPaths = outputFileListPaths
        self.showEnvVarsInLog = showEnvVarsInLog
        self.basedOnDependencyAnalysis = basedOnDependencyAnalysis
    }

    /// Initializes a new target action with its attributes.
    ///
    /// - Parameters:
    ///   - name: Name of the build phase when the project gets generated
    ///   - order: Target action order
    ///   - script: The text of the script to run. This should be kept small.
    ///   - inputPaths: List of input file paths
    ///   - inputFileListPaths: List of input filelist paths
    ///   - outputPaths: List of output file paths
    ///   - outputFileListPaths: List of output filelist paths
    ///   - showEnvVarsInLog: Show environment variables in the logs
    ///   - basedOnDependencyAnalysis: Whether to skip running this script in incremental builds
    public init(name: String,
                order: Order,
                script: String,
                inputPaths: [AbsolutePath] = [],
                inputFileListPaths: [AbsolutePath] = [],
                outputPaths: [AbsolutePath] = [],
                outputFileListPaths: [AbsolutePath] = [],
                showEnvVarsInLog: Bool = true,
                basedOnDependencyAnalysis: Bool? = nil)
    {
        self.name = name
        self.order = order
        self.script = .text(script)
        self.inputPaths = inputPaths
        self.inputFileListPaths = inputFileListPaths
        self.outputPaths = outputPaths
        self.outputFileListPaths = outputFileListPaths
        self.showEnvVarsInLog = showEnvVarsInLog
        self.basedOnDependencyAnalysis = basedOnDependencyAnalysis
    }

    /// Returns the shell script that should be used in the target build phase.
    ///
    /// - Parameters:
    ///   - sourceRootPath: Path to the directory where the Xcode project is generated.
    /// - Returns: Shell script that should be used in the target build phase.
    /// - Throws: An error if the tool absolute path cannot be obtained.
    public func shellScript(sourceRootPath: AbsolutePath) throws -> String {
        if case let Script.text(text) = script {
            return text
        } else if let path = path {
            return "\"${PROJECT_DIR}\"/\(path.relative(to: sourceRootPath).pathString) \(arguments.joined(separator: " "))"
        } else {
            return try "\(System.shared.which(tool!).spm_chomp().spm_chuzzle()!) \(arguments.joined(separator: " "))"
        }
    }
}

extension Array where Element == TargetAction {
    public var preActions: [TargetAction] {
        filter { $0.order == .pre }
    }

    public var postActions: [TargetAction] {
        filter { $0.order == .post }
    }
}
