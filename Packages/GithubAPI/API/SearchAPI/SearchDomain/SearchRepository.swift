import Foundation

public protocol SearchRepository {
    func searchRepositories(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubRepositorySummary]

    func searchUsers(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubUserProfile]
}
