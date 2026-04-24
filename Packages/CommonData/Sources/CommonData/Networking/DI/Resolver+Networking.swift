import Foundation
import Resolver

public extension Resolver {
    func registerNetworkLogger(
        subsystem: String = Bundle.main.bundleIdentifier ?? "Github",
        category: String = "Networking"
    ) {
        register(NetworkLogger.self) {
            DefaultNetworkLogger(
                subsystem: subsystem,
                category: category
            )
        }
        .scope(.application)
    }

    func registerNetworkClient(
        interceptors: [RequestInterceptor] = [],
        errorListeners: [APIErrorListener] = []
    ) {
        register(NetworkClient.self) {
            let config: DataSourceConfig = self.resolve()
            let logger = self.optional(NetworkLogger.self)
                ?? DefaultNetworkLogger()

            return NetworkClientFactory.live(
                config: config,
                interceptors: interceptors,
                errorListeners: errorListeners,
                logger: logger
            )
        }
        .scope(.application)
    }
}
