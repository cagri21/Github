import Foundation

public enum NetworkError: LocalizedError {
    case invalidResponse
    case unexpectedStatusCode(statusCode: Int, payload: Data?)
    case requestEncodingFailed(Error)
    case responseDecodingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server response was invalid."
        case let .unexpectedStatusCode(statusCode, payload):
            guard
                let payload,
                let payloadString = String(data: payload, encoding: .utf8),
                !payloadString.isEmpty
            else {
                return "Request failed with status code \(statusCode)."
            }

            return "Request failed with status code \(statusCode): \(payloadString)"
        case let .requestEncodingFailed(error):
            return "Request encoding failed: \(error.localizedDescription)"
        case let .responseDecodingFailed(error):
            return "Response decoding failed: \(error.localizedDescription)"
        }
    }
}
