import Foundation

public final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let logger: any NetworkLogger
    private let responseValidator: any NetworkResponseValidator

    public init(
        session: URLSession,
        logger: any NetworkLogger = DefaultNetworkLogger(),
        responseValidator: any NetworkResponseValidator = HTTPStatusCodeNetworkResponseValidator()
    ) {
        self.session = session
        self.logger = logger
        self.responseValidator = responseValidator
    }

    public func network<Response: Decodable>(
        _ request: Request<Response, some Encodable>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) async throws -> Response {
        let urlRequest = try request.urlRequest(encoder: encoder)

        return try await execute(
            urlRequest,
            delegate: delegate
        ) { data in
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkError.responseDecodingFailed(error)
            }
        }
    }

    public func network(
        _ request: Request<Void, some Encodable>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) async throws {
        let urlRequest = try request.urlRequest(encoder: encoder)

        _ = try await execute(
            urlRequest,
            delegate: delegate
        ) { _ in () }
    }

    public func network<Response: Decodable>(
        _ request: Request<Response, Never>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder
    ) async throws -> Response {
        let urlRequest = request.urlRequest()

        return try await execute(
            urlRequest,
            delegate: delegate
        ) { data in
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkError.responseDecodingFailed(error)
            }
        }
    }

    public func networkData(
        _ request: Request<Data, Never>,
        delegate: URLSessionTaskDelegate?
    ) async throws -> Data {
        try await execute(
            request.urlRequest(),
            delegate: delegate
        ) { data in
            data
        }
    }
}

private extension URLSessionNetworkClient {
    func execute<Response>(
        _ request: URLRequest,
        delegate: URLSessionTaskDelegate?,
        transform: (Data) throws -> Response
    ) async throws -> Response {
        let startedAt = Date()
        logger.requestDidStart(request)

        do {
            let (data, response) = try await session.data(
                for: request,
                delegate: delegate
            )
            let httpResponse = try responseValidator.validate(
                response: response,
                data: data
            )
            let value = try transform(data)

            logger.requestDidSucceed(
                request,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(startedAt)
            )

            return value
        } catch {
            logger.requestDidFail(
                request,
                error: error,
                duration: Date().timeIntervalSince(startedAt)
            )
            throw error
        }
    }
}
