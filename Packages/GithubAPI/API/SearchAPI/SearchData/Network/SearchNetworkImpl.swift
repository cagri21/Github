import CommonData
import Foundation

public final class SearchNetworkImpl: SearchNetwork {
    private let client: NetworkClient
    private let config: DataSourceConfig

    public init(
        client: NetworkClient,
        config: DataSourceConfig
    ) {
        self.client = client
        self.config = config
    }

    public func searchRepositories(
        _ requestQuery: SearchRequestQuery
    ) async throws -> GithubRepositorySearchResponseEntity {
        try await client.network(
            .searchRepositories(
                requestQuery,
                config: config
            )
        )
    }

    public func searchUsers(
        _ requestQuery: SearchRequestQuery
    ) async throws -> GithubUserSearchResponseEntity {
        try await client.network(
            .searchUsers(
                requestQuery,
                config: config
            )
        )
    }
}
