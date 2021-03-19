import Foundation
import TuistGraph

public extension IDETemplateMacros {
    static func test(fileHeader: String? = "Header template") -> IDETemplateMacros {
        IDETemplateMacros(fileHeader: fileHeader)
    }
}
