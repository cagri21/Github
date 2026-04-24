import Foundation
import Pulse

public extension URLSession {
    static func configured(
        with config: DataSourceConfig
    ) -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpAdditionalHeaders = config.defaultHeaders

        return URLSession(
            configuration: sessionConfiguration,
            delegate: URLSessionProxyDelegate(),
            delegateQueue: nil
        )
    }
}
