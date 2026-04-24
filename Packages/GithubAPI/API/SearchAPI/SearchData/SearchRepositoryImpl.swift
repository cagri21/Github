import Foundation
import SearchDomain

public struct SearchRepositoryImpl: SearchRepository {
    private let network: SearchNetwork

    public init(network: SearchNetwork) {
        self.network = network
    }

    public func searchRepositories(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubRepositorySummary] {
        let requestQuery = SearchRequestQuery(
            query: query,
            perPage: limit,
            page: page
        )
        let response = try await network.searchRepositories(requestQuery)

        return response.items
            .map(GithubRepositorySummary.init(entity:))
            .sorted { lhs, rhs in
                lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    public func searchUsers(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubUserProfile] {
        let requestQuery = SearchRequestQuery(
            query: query,
            perPage: limit,
            page: page
        )
        let response = try await network.searchUsers(requestQuery)

        return response.items
            .map(GithubUserProfile.init(entity:))
            .sorted { lhs, rhs in
                lhs.login.localizedCaseInsensitiveCompare(rhs.login) == .orderedAscending
            }
    }
}
