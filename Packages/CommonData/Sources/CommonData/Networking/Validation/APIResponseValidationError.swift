import Foundation

public enum APIResponseValidationError: LocalizedError {
    case invalidStatusCode(expected: Int, actual: Int?)
    case custom(code: String, message: String)

    public var errorDescription: String? {
        switch self {
        case let .invalidStatusCode(expected, actual):
            return "Expected API status code \(expected), received \(actual.map(String.init) ?? "nil")."
        case let .custom(code, message):
            return "[\(code)] \(message)"
        }
    }
}
