import Foundation

public struct SearchServiceImpl: SearchService {
    private let repository: SearchRepository

    public init(repository: SearchRepository) {
        self.repository = repository
    }

    public func searchRepositories(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubRepositorySummary] {
        try await repository.searchRepositories(
            query: query,
            limit: limit,
            page: page
        )
    }

    public func searchUsers(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubUserProfile] {
        try await repository.searchUsers(
            query: query,
            limit: limit,
            page: page
        )
    }
}
