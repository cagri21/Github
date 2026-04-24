import Foundation

public final class RequestInterceptingNetworkClient: NetworkClient {
    private let wrapped: NetworkClient
    private let interceptors: [RequestInterceptor]
    private let errorListeners: [APIErrorListener]
    private let logger: any NetworkLogger

    public init(
        wrapping wrapped: NetworkClient,
        interceptors: [RequestInterceptor],
        errorListeners: [APIErrorListener],
        logger: any NetworkLogger = DefaultNetworkLogger()
    ) {
        self.wrapped = wrapped
        self.interceptors = interceptors
        self.errorListeners = errorListeners
        self.logger = logger
    }

    public func network<Response: Decodable>(
        _ request: Request<Response, some Encodable>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) async throws -> Response {
        let request = try await applyInterceptors(to: request)

        return try await notifyingListenersOnError(request) {
            try await wrapped.network(
                request,
                delegate: delegate,
                decoder: decoder,
                encoder: encoder
            )
        }
    }

    public func network(
        _ request: Request<Void, some Encodable>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) async throws {
        let request = try await applyInterceptors(to: request)

        try await notifyingListenersOnError(request) {
            try await wrapped.network(
                request,
                delegate: delegate,
                decoder: decoder,
                encoder: encoder
            )
        }
    }

    public func network<Response: Decodable>(
        _ request: Request<Response, Never>,
        delegate: URLSessionTaskDelegate?,
        decoder: JSONDecoder
    ) async throws -> Response {
        let request = try await applyInterceptors(to: request)

        return try await notifyingListenersOnError(request) {
            try await wrapped.network(
                request,
                delegate: delegate,
                decoder: decoder
            )
        }
    }

    public func networkData(
        _ request: Request<Data, Never>,
        delegate: URLSessionTaskDelegate?
    ) async throws -> Data {
        let request = try await applyInterceptors(to: request)

        return try await notifyingListenersOnError(request) {
            try await wrapped.networkData(
                request,
                delegate: delegate
            )
        }
    }
}

private extension RequestInterceptingNetworkClient {
    func applyInterceptors<Response, Body>(
        to request: Request<Response, Body>
    ) async throws -> Request<Response, Body> {
        var request = request

        for interceptor in interceptors {
            do {
                request = try await interceptor.intercept(request)
            } catch {
                logger.requestInterceptionDidFail(
                    requestURL: request.url,
                    error: error
                )
                throw error
            }
        }

        return request
    }

    func notifyingListenersOnError<Response, Body>(
        _ request: Request<Response, Body>,
        _ block: () async throws -> Response
    ) async throws -> Response {
        do {
            return try await block()
        } catch {
            notifyErrorListeners(
                error: error,
                requestURL: request.url
            )
            throw error
        }
    }

    func notifyErrorListeners(
        error: Error,
        requestURL: URL
    ) {
        for listener in errorListeners {
            listener.errorOccurred(
                error: error,
                requestURL: requestURL
            )
        }
    }
}
