import Basic
import Foundation
import TuistCore
import TuistSupport

/// A component responsible for generating Xcode projects & workspaces
@available(
    *,
    deprecated,
    message: "Generating is deprecated and will be removed in a future Tuist version. Please use `DescriptorGenerating` instead."
)
public protocol Generating {
    /// Generates an Xcode project at a given path. Only the specified project is generated (excluding its dependencies).
    ///
    /// - Parameters:
    ///   - path: The absolute path to the directory where an Xcode project should be generated
    /// - Returns: An absolute path to the generated Xcode project many of which adopt `FatalError`
    /// - Throws: Errors encountered during the generation process
    /// - seealso: TuistCore.FatalError
    func generateProject(at path: AbsolutePath) throws -> (AbsolutePath, Graphing)

    /// Generates the given project in the same directory where it's defined.
    /// - Parameters:
    ///     - project: The project to be generated.
    ///     - graph: The dependencies graph.
    ///     - sourceRootPath: The path all the files in the Xcode project will be realtived to. When it's nil, it's assumed that all the paths are relative to the directory that contains the manifest.
    ///     - xcodeprojPath: Path where the .xcodeproj directory will be generated. When the attribute is nil, the project is generated in the manifest's directory.
    func generateProject(_ project: Project, graph: Graphing, sourceRootPath: AbsolutePath?, xcodeprojPath: AbsolutePath?) throws -> AbsolutePath

    /// Generate an Xcode workspace for the project at a given path. All the project's dependencies will also be generated and included.
    ///
    /// - Parameters:
    ///   - path: The absolute path to the directory where an Xcode workspace should be generated
    ///           (e.g. /path/to/directory)
    ///   - workspaceFiles: Additional files to include in the final generated workspace
    /// - Returns: An absolute path to the generated Xcode workspace
    ///            (e.g. /path/to/directory/project.xcodeproj)
    /// - Throws: Errors encountered during the generation process
    ///           many of which adopt `FatalError`
    /// - seealso: TuistCore.FatalError
    @discardableResult
    func generateProjectWorkspace(at path: AbsolutePath, workspaceFiles: [AbsolutePath]) throws -> (AbsolutePath, Graphing)

    /// Generate an Xcode workspace at a given path. All referenced projects and their dependencies will be generated and included.
    ///
    /// - Parameters:
    ///   - path: The absolute path to the directory where an Xcode workspace should be generated
    ///           (e.g. /path/to/directory)
    ///   - workspaceFiles: Additional files to include in the final generated workspace
    /// - Returns: An absolute path to the generated Xcode workspace
    ///            (e.g. /path/to/directory/project.xcodeproj)
    /// - Throws: Errors encountered during the generation process
    ///           many of which adopt `FatalError`
    /// - seealso: TuistCore.FatalError
    @discardableResult
    func generateWorkspace(at path: AbsolutePath, workspaceFiles: [AbsolutePath]) throws -> (AbsolutePath, Graphing)
}

/// A default implementation of `Generating`
///
/// - seealso: Generating
/// - seealso: GeneratorModelLoading
@available(
    *,
    deprecated,
    message: "Generator is deprecated and will be removed in a future Tuist version. Please use `DescriptorGenerator` instead."
)
public class Generator: Generating {
    private let graphLoader: GraphLoading
    private let graphLinter: GraphLinting
    private let workspaceGenerator: WorkspaceGenerating
    private let projectGenerator: ProjectGenerating
    private let writer: XcodeProjWriting

    /// Instance to lint the Tuist configuration against the system.
    private let environmentLinter: EnvironmentLinting

    public convenience init(defaultSettingsProvider: DefaultSettingsProviding = DefaultSettingsProvider(),
                            modelLoader: GeneratorModelLoading) {
        let graphLinter = GraphLinter()
        let graphLoader = GraphLoader(modelLoader: modelLoader)
        let configGenerator = ConfigGenerator(defaultSettingsProvider: defaultSettingsProvider)
        let targetGenerator = TargetGenerator(configGenerator: configGenerator)
        let projectGenerator = ProjectGenerator(targetGenerator: targetGenerator,
                                                configGenerator: configGenerator)
        let environmentLinter = EnvironmentLinter()
        let workspaceStructureGenerator = WorkspaceStructureGenerator()
        let schemesGenerator = SchemesGenerator()
        let workspaceGenerator = WorkspaceGenerator(projectGenerator: projectGenerator,
                                                    workspaceStructureGenerator: workspaceStructureGenerator,
                                                    schemesGenerator: schemesGenerator)
        let writer = XcodeProjWriter()
        self.init(graphLoader: graphLoader,
                  graphLinter: graphLinter,
                  workspaceGenerator: workspaceGenerator,
                  projectGenerator: projectGenerator,
                  environmentLinter: environmentLinter,
                  writer: writer)
    }

    init(graphLoader: GraphLoading,
         graphLinter: GraphLinting,
         workspaceGenerator: WorkspaceGenerating,
         projectGenerator: ProjectGenerating,
         environmentLinter: EnvironmentLinting,
         writer: XcodeProjWriting) {
        self.graphLoader = graphLoader
        self.graphLinter = graphLinter
        self.workspaceGenerator = workspaceGenerator
        self.projectGenerator = projectGenerator
        self.environmentLinter = environmentLinter
        self.writer = writer
    }

    public func generateProject(_ project: Project,
                                graph: Graphing,
                                sourceRootPath: AbsolutePath? = nil,
                                xcodeprojPath: AbsolutePath? = nil) throws -> AbsolutePath {
        /// When the source root path is not given, we assume paths
        /// are relative to the directory that contains the manifest.
        let sourceRootPath = sourceRootPath ?? project.path

        let descriptor = try projectGenerator.generate(project: project,
                                                       graph: graph,
                                                       sourceRootPath: sourceRootPath,
                                                       xcodeprojPath: xcodeprojPath)

        try writer.write(project: descriptor)
        return descriptor.path
    }

    public func generateProject(at path: AbsolutePath) throws -> (AbsolutePath, Graphing) {
        let config = try graphLoader.loadConfig(path: path)
        try environmentLinter.lint(config: config).printAndThrowIfNeeded()

        let (graph, project) = try graphLoader.loadProject(path: path)
        try graphLinter.lint(graph: graph).printAndThrowIfNeeded()

        let descriptor = try projectGenerator.generate(project: project,
                                                       graph: graph,
                                                       sourceRootPath: path,
                                                       xcodeprojPath: nil)

        try writer.write(project: descriptor)
        return (descriptor.path, graph)
    }

    public func generateProjectWorkspace(at path: AbsolutePath,
                                         workspaceFiles: [AbsolutePath]) throws -> (AbsolutePath, Graphing) {
        let config = try graphLoader.loadConfig(path: path)
        try environmentLinter.lint(config: config).printAndThrowIfNeeded()

        let (graph, project) = try graphLoader.loadProject(path: path)
        try graphLinter.lint(graph: graph).printAndThrowIfNeeded()

        let workspace = Workspace(path: path,
                                  name: project.name,
                                  projects: graph.projectPaths,
                                  additionalFiles: workspaceFiles.map(FileElement.file))

        let descriptor = try workspaceGenerator.generate(workspace: workspace,
                                                         path: path,
                                                         graph: graph)
        try writer.write(workspace: descriptor)
        return (descriptor.path, graph)
    }

    public func generateWorkspace(at path: AbsolutePath,
                                  workspaceFiles: [AbsolutePath]) throws -> (AbsolutePath, Graphing) {
        let config = try graphLoader.loadConfig(path: path)
        try environmentLinter.lint(config: config).printAndThrowIfNeeded()
        let (graph, workspace) = try graphLoader.loadWorkspace(path: path)
        try graphLinter.lint(graph: graph).printAndThrowIfNeeded()

        let updatedWorkspace = workspace
            .merging(projects: graph.projectPaths)
            .adding(files: workspaceFiles)

        let descriptor = try workspaceGenerator.generate(workspace: updatedWorkspace,
                                                         path: path,
                                                         graph: graph)
        try writer.write(workspace: descriptor)
        return (descriptor.path, graph)
    }
}
