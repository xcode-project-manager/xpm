import Foundation
import RxBlocking
import Signals
import TSCBasic
import TuistCore
import TuistDoc
import TuistSupport

// MARK: - Error

enum DocServiceError: FatalError, Equatable {
    case targetNotFound(name: String)
    case documentationNotGenerated
    
    var description: String {
        switch self {
        case let .targetNotFound(name):
            return "The target \(name) is not visible in the current project."
        case .documentationNotGenerated:
            return "The documentation was not generated. Problably the provided target does not have public symbols."
        }
    }
    
    var type: ErrorType {
        switch self {
        case .targetNotFound:
            return .abort
        case .documentationNotGenerated:
            return .abort
        }
    }
}

// MARK: - DocServicing

protocol DocServicing {
    func run(path: AbsolutePath) throws
}

// MARK: - DocService

struct DocService {
    private let projectGenerator: ProjectGenerating
    private let swiftDocController: SwiftDocControlling
    private let swiftDocServer: SwiftDocServing
    private let fileHandler: FileHandling

    init(projectGenerator: ProjectGenerating = ProjectGenerator(),
         swiftDocController: SwiftDocControlling = SwiftDocController(),
         swiftDocServer: SwiftDocServing = SwiftDocServer(),
         fileHandler: FileHandling = FileHandler.shared)
    {
        self.projectGenerator = projectGenerator
        self.swiftDocController = swiftDocController
        self.swiftDocServer = swiftDocServer
        self.fileHandler = fileHandler
    }

    func run(project path: AbsolutePath, target targetName: String) throws {
        let (_, graph, _) = try projectGenerator.loadProject(path: path)

        let targets = graph.targets(at: path)
            .filter { !$0.dependsOnXCTest }
            .map { $0.target }

        guard let target = targets.first(where: { $0.name == targetName }) else {
            throw DocServiceError.targetNotFound(name: targetName)
        }

        let sources = target.sources.map(\.path)
        let format: SwiftDocFormat = .html
        let indexName = "index.html"
        let port: UInt16 = 4040
        
        let baseURL = type(of: swiftDocServer).baseURL.appending(":\(port)")
        
        try withTemporaryDirectory { generationDirectory in

            try swiftDocController.generate(
                format: format,
                moduleName: targetName,
                baseURL: baseURL,
                outputDirectory: generationDirectory.pathString,
                sourcesPaths: sources
            )

            let indexPath = generationDirectory.appending(component: indexName)

            guard fileHandler.exists(indexPath) else {
                throw DocServiceError.documentationNotGenerated
            }

            try swiftDocServer.serve(path: generationDirectory, port: port)
        }
    }
}
