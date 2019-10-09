import Foundation
import XCTest

@testable import TuistCore

public class TuistUnitTestCase: TuistTestCase {
    public var system: MockSystem!
    public var printer: MockPrinter!
    public var fileHandler: MockFileHandler!
    public var environment: MockEnvironment!
    public var xcodeController: MockXcodeController!

    public override func setUp() {
        super.setUp()
        // System
        system = MockSystem()
        System.shared = system

        // Printer
        printer = MockPrinter()
        Printer.shared = printer

        // File handler
        // swiftlint:disable force_try
        fileHandler = try! MockFileHandler()
        FileHandler.shared = fileHandler

        // Xcode controller
        xcodeController = MockXcodeController()
        XcodeController.shared = xcodeController

        // Environment
        // swiftlint:disable force_try
        environment = try! MockEnvironment()
        Environment.shared = environment
    }

    public override func tearDown() {
        // System
        system = nil
        System.shared = System()

        // Printer
        printer = nil
        Printer.shared = Printer()

        // File handler
        fileHandler = nil
        FileHandler.shared = FileHandler()

        // Xcode controller
        xcodeController = nil
        XcodeController.shared = XcodeController()

        // Environment
        environment = nil
        Environment.shared = Environment()

        super.tearDown()
    }
}
