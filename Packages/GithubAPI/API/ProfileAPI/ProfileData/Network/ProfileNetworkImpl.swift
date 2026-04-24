import CommonData
import Foundation
import ProfileDomain

public final class ProfileNetworkImpl: ProfileNetwork {
    private let client: NetworkClient
    private let config: DataSourceConfig

    public init(
        client: NetworkClient,
        config: DataSourceConfig
    ) {
        self.client = client
        self.config = config
    }

    public func fetchProfile() async throws -> ProfileEnvelopeEntity {
        try await client.network(
            .fetchProfile(config: config)
        )
    }

    public func updateProfile(_ payload: UpdateProfilePayload) async throws -> ProfileEnvelopeEntity {
        try await client.network(
            .updateProfile(
                payload,
                config: config
            )
        )
    }
}
