import Foundation

public protocol NetworkResponseValidator {
    func validate(
        response: URLResponse,
        data: Data
    ) throws -> HTTPURLResponse
}
