import Foundation

struct DataError {
    let description: String
}

extension DataError: Error {}
extension DataError: CustomDebugStringConvertible {
    var debugDescription: String { description }
}
