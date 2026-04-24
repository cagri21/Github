public protocol RequestInterceptor {
    func intercept<Response, Body>(
        _ request: Request<Response, Body>
    ) async throws -> Request<Response, Body>
}
