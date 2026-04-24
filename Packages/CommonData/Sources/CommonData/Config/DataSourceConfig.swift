import Foundation

public protocol DataSourceConfig {
    var baseURL: URL { get }
    var apiKey: String? { get }
    var contentType: String { get }
    var userAgent: String? { get }
    var acceptLanguage: String? { get }
}

public extension DataSourceConfig {
    var apiKey: String? { nil }
    var contentType: String { "application/json" }
    var userAgent: String? { nil }
    var acceptLanguage: String? { nil }

    var defaultHeaders: [String: String] {
        var headers = [String: String]()

        headers["Content-Type"] = contentType

        if let apiKey, !apiKey.isEmpty {
            headers["x-api-key"] = apiKey
        }

        if let userAgent, !userAgent.isEmpty {
            headers["User-Agent"] = userAgent
        }

        if let acceptLanguage, !acceptLanguage.isEmpty {
            headers["Accept-Language"] = acceptLanguage
        }

        return headers
    }
}
