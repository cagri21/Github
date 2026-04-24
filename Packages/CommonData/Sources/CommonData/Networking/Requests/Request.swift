import Foundation

private func buildQueryItems(
    from value: some Encodable,
    encoder: JSONEncoder = .default
) -> [URLQueryItem] {
    guard
        let data = try? encoder.encode(value),
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
        return []
    }

    var items = [URLQueryItem]()

    for (key, rawValue) in json {
        switch rawValue {
        case let string as String where !string.isEmpty:
            items.append(URLQueryItem(name: key, value: string))
        case let number as NSNumber:
            let value = CFGetTypeID(number) == CFBooleanGetTypeID()
                ? (number.boolValue ? "true" : "false")
                : number.stringValue
            items.append(URLQueryItem(name: key, value: value))
        case let bool as Bool:
            items.append(URLQueryItem(name: key, value: bool ? "true" : "false"))
        case is NSNull:
            continue
        case let array as [Any]:
            for value in array {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
        default:
            items.append(URLQueryItem(name: key, value: "\(rawValue)"))
        }
    }

    return items.sorted { $0.name < $1.name }
}

public struct Request<Response, Body> {
    public let url: URL
    public let method: HTTPMethod<Body>
    public var headers: [String: String]

    public init(
        url: URL,
        method: HTTPMethod<Body>,
        headers: [String: String] = [:]
    ) {
        self.url = url
        self.method = method
        self.headers = headers
    }

    public init(
        baseURL: URL,
        path: String,
        method: HTTPMethod<Body>,
        headers: [String: String] = [:]
    ) {
        guard let url = URL(string: "\(baseURL.absoluteString)\(path)") else {
            preconditionFailure("Failed to build a URL from \(baseURL.absoluteString) and \(path)")
        }

        self.init(
            url: url,
            method: method,
            headers: headers
        )
    }
}

public extension Request where Body: Encodable {
    func urlRequest(
        encoder: JSONEncoder = .default
    ) throws -> URLRequest {
        var request = URLRequest(url: url)

        do {
            switch method {
            case let .post(body), let .put(body), let .patch(body):
                request.httpBody = try encoder.encode(body)
            case .get, .delete, .head:
                break
            }
        } catch {
            throw NetworkError.requestEncodingFailed(error)
        }

        var finalHeaders = headers

        if finalHeaders["Content-Type"] == nil {
            finalHeaders["Content-Type"] = "application/json"
        }

        request.allHTTPHeaderFields = finalHeaders
        request.httpMethod = method.name
        return request
    }
}

public extension Request where Body == Never {
    func urlRequest() -> URLRequest {
        var request = URLRequest(url: url)

        switch method {
        case let .get(queryItems) where !queryItems.isEmpty:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems

            guard let queryURL = components?.url else {
                preconditionFailure("Failed to build a URL with query items.")
            }

            request = URLRequest(url: queryURL)
        case .get, .delete, .head, .post, .put, .patch:
            break
        }

        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }

    init(
        baseURL: URL,
        path: String,
        headers: [String: String] = [:],
        query: some Encodable
    ) {
        guard let url = URL(string: "\(baseURL.absoluteString)\(path)") else {
            preconditionFailure("Failed to build a URL from \(baseURL.absoluteString) and \(path)")
        }

        self.url = url
        self.method = .get(buildQueryItems(from: query))
        self.headers = headers
    }
}
