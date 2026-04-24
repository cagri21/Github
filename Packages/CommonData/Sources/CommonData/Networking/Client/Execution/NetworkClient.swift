import Foundation

public protocol NetworkClient {
    func network<Response: Decodable>(
        _ request: Request<Response, some Encodable>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) async throws -> Response

    func network(
        _ request: Request<Void, some Encodable>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) async throws

    func network<Response: Decodable>(
        _ request: Request<Response, Never>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder
    ) async throws -> Response

    func networkData(
        _ request: Request<Data, Never>,
        delegate: URLSessionTaskDelegate?
    ) async throws -> Data
}

public extension NetworkClient {
    func network<Response: Decodable>(
        _ request: Request<Response, some Encodable>,
        delegate: URLSessionTaskDelegate? = nil,
        decoder: JSONDecoder = .default,
        encoder: JSONEncoder = .default
    ) async throws -> Response {
        try await network(
            request,
            delegate: delegate,
            decoder: decoder,
            encoder: encoder
        )
    }

    func network(
        _ request: Request<Void, some Encodable>,
        delegate: URLSessionTaskDelegate? = nil,
        decoder: JSONDecoder = .default,
        encoder: JSONEncoder = .default
    ) async throws {
        try await network(
            request,
            delegate: delegate,
            decoder: decoder,
            encoder: encoder
        )
    }

    func network<Response: Decodable>(
        _ request: Request<Response, Never>,
        delegate: URLSessionTaskDelegate? = nil,
        decoder: JSONDecoder = .default
    ) async throws -> Response {
        try await network(
            request,
            delegate: delegate,
            decoder: decoder
        )
    }

    func networkData(
        _ request: Request<Data, Never>,
        delegate: URLSessionTaskDelegate? = nil
    ) async throws -> Data {
        try await networkData(
            request,
            delegate: delegate
        )
    }
}
