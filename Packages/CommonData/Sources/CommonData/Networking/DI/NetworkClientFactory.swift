import Foundation

public enum NetworkClientFactory {
    public static func live(
        config: DataSourceConfig,
        session: URLSession? = nil,
        interceptors: [RequestInterceptor] = [],
        errorListeners: [APIErrorListener] = [],
        logger: any NetworkLogger = DefaultNetworkLogger()
    ) -> NetworkClient {
        let activeSession = session ?? URLSession.configured(with: config)
        let transportClient = URLSessionNetworkClient(
            session: activeSession,
            logger: logger
        )

        return RequestInterceptingNetworkClient(
            wrapping: transportClient,
            interceptors: interceptors,
            errorListeners: errorListeners,
            logger: logger
        )
    }
}
