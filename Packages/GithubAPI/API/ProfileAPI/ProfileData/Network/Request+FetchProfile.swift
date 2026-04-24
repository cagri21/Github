import CommonData
import Foundation

extension Request where Response == ProfileEnvelopeEntity, Body == Never {
    static func fetchProfile(
        config: DataSourceConfig
    ) -> Self {
        Request(
            baseURL: config.baseURL,
            path: "/profile",
            method: .get(),
            headers: config.defaultHeaders
        )
    }
}
