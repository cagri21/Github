import Foundation
import OSLog

public struct DefaultNetworkLogger: NetworkLogger {
    private let logger: Logger
    private let payloadPreviewLimit: Int

    public init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "CommonData",
        category: String = "Networking",
        payloadPreviewLimit: Int = 1_024
    ) {
        logger = Logger(
            subsystem: subsystem,
            category: category
        )
        self.payloadPreviewLimit = payloadPreviewLimit
    }

    public func requestDidStart(_ request: URLRequest) {
        logger.debug(
            "Started \(requestSummary(for: request), privacy: .public)"
        )

        if let bodyPreview = preview(of: request.httpBody), !bodyPreview.isEmpty {
            logger.debug("Request body: \(bodyPreview, privacy: .public)")
        }
    }

    public func requestDidSucceed(
        _ request: URLRequest,
        response: HTTPURLResponse,
        data: Data,
        duration: TimeInterval
    ) {
        logger.debug(
            """
            Finished \(requestSummary(for: request), privacy: .public) \
            status=\(response.statusCode, privacy: .public) \
            duration=\(formatted(duration), privacy: .public)
            """
        )

        if let bodyPreview = preview(of: data), !bodyPreview.isEmpty {
            logger.debug("Response body: \(bodyPreview, privacy: .public)")
        }
    }

    public func requestDidFail(
        _ request: URLRequest?,
        error: Error,
        duration: TimeInterval?
    ) {
        let requestDescription = request.map(requestSummary(for:)) ?? "request"
        let durationDescription = duration.map { formatted($0) } ?? "n/a"

        logger.error(
            """
            Failed \(requestDescription, privacy: .public) \
            duration=\(durationDescription, privacy: .public) \
            error=\(error.localizedDescription, privacy: .public)
            """
        )
    }

    public func requestInterceptionDidFail(
        requestURL: URL,
        error: Error
    ) {
        logger.error(
            """
            Interceptor failed for \(requestURL.absoluteString, privacy: .public) \
            error=\(error.localizedDescription, privacy: .public)
            """
        )
    }
}

private extension DefaultNetworkLogger {
    func requestSummary(
        for request: URLRequest
    ) -> String {
        let method = request.httpMethod ?? "REQUEST"
        let url = request.url?.absoluteString ?? "unknown-url"

        return "\(method) \(url)"
    }

    func preview(
        of data: Data?
    ) -> String? {
        guard let data, !data.isEmpty else {
            return nil
        }

        if let rawPreview = String(
            data: data.prefix(payloadPreviewLimit),
            encoding: .utf8
        ) {
            if data.count > payloadPreviewLimit {
                return "\(rawPreview)…"
            }

            return rawPreview
        }

        return "<\(data.count) bytes>"
    }

    func formatted(
        _ duration: TimeInterval
    ) -> String {
        String(format: "%.3fs", duration)
    }
}
