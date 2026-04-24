import Foundation
import GithubAPI

protocol GithubSearchAutocompleteUseCase {
    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch
}

struct GithubSearchAutocompleteUseCaseImpl: GithubSearchAutocompleteUseCase {
    private let perEndpointResultCount: Int
    private let service: SearchService

    init(
        service: SearchService,
        perEndpointResultCount: Int = GithubSearchAutocompleteConfiguration.Search.perEndpointResultCount
    ) {
        self.perEndpointResultCount = perEndpointResultCount
        self.service = service
    }

    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch {
        async let repositorySearch = searchRepositoriesResult(
            query: query,
            limit: perEndpointResultCount,
            page: page
        )
        async let userSearch = searchUsersResult(
            query: query,
            limit: perEndpointResultCount,
            page: page
        )

        let repositoryResult = await repositorySearch
        let userResult = await userSearch
        let repositorySuggestions = repositoryResult.suggestions(using: GithubSearchSuggestion.repository)
        let userSuggestions = userResult.suggestions(using: GithubSearchSuggestion.user)
        let suggestions = repositorySuggestions + userSuggestions

        if suggestions.isEmpty,
           let error = repositoryResult.error ?? userResult.error {
            throw error
        }

        return GithubSearchAutocompleteBatch(
            suggestions: suggestions
                .sorted { lhs, rhs in
                    lhs.sortValue.localizedCaseInsensitiveCompare(rhs.sortValue) == .orderedAscending
                },
            hasMoreResults: repositorySuggestions.count == perEndpointResultCount
                || userSuggestions.count == perEndpointResultCount
        )
    }
}

private extension GithubSearchAutocompleteUseCaseImpl {
    func searchRepositoriesResult(
        query: String,
        limit: Int,
        page: Int
    ) async -> Result<[GithubRepositorySummary], Error> {
        do {
            let repositories = try await service.searchRepositories(
                query: query,
                limit: limit,
                page: page
            )
            return .success(repositories)
        } catch {
            return .failure(error)
        }
    }

    func searchUsersResult(
        query: String,
        limit: Int,
        page: Int
    ) async -> Result<[GithubUserProfile], Error> {
        do {
            let users = try await service.searchUsers(
                query: query,
                limit: limit,
                page: page
            )
            return .success(users)
        } catch {
            return .failure(error)
        }
    }
}

private extension Result {
    var error: Failure? {
        if case let .failure(error) = self {
            return error
        }

        return nil
    }

    func suggestions(
        using transform: (Success.Element) -> GithubSearchSuggestion
    ) -> [GithubSearchSuggestion] where Success: Sequence {
        guard case let .success(values) = self else {
            return []
        }

        return values.map(transform)
    }
}
