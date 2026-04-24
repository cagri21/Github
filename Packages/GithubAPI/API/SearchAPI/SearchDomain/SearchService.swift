import Foundation

public protocol SearchService {
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
