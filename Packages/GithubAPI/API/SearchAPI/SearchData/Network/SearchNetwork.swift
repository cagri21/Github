import Foundation

public protocol SearchNetwork {
    func searchRepositories(
        _ requestQuery: SearchRequestQuery
    ) async throws -> GithubRepositorySearchResponseEntity

    func searchUsers(
        _ requestQuery: SearchRequestQuery
    ) async throws -> GithubUserSearchResponseEntity
}
