import CommonData
import Foundation
import ProfileDomain

extension Request where Response == ProfileEnvelopeEntity, Body == UpdateProfilePayload {
    static func updateProfile(
        _ payload: UpdateProfilePayload,
        config: DataSourceConfig
    ) -> Self {
        Request(
            baseURL: config.baseURL,
            path: "/profile",
            method: .put(payload),
            headers: config.defaultHeaders
        )
    }
}
