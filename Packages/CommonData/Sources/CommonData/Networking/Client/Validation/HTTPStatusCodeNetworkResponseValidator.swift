import Foundation

public struct HTTPStatusCodeNetworkResponseValidator: NetworkResponseValidator {
    public init() {}

    public func validate(
        response: URLResponse,
        data: Data
    ) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            throw NetworkError.unexpectedStatusCode(
                statusCode: httpResponse.statusCode,
                payload: data
            )
        }

        return httpResponse
    }
}
