import Foundation
@testable import Github
import GithubAPI
import Testing

@Suite("Search autocomplete use case")
struct GithubSearchAutocompleteUseCaseTests {
    @Test func requestsFiftyFromEachEndpointAndSortsMergedResults() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let perEndpointResultCount = GithubSearchAutocompleteConfiguration.Search.perEndpointResultCount
        let service = SearchServiceSpy(
            repositoryPages: [
                initialPage: [
                    makeRepositorySummary(
                        id: 1,
                        name: "ZetaKit",
                        ownerLogin: "team-z",
                        starCount: 4_200
                    ),
                    makeRepositorySummary(
                        id: 2,
                        name: "AlphaKit",
                        ownerLogin: "team-a",
                        starCount: 1_100
                    )
                ]
            ],
            userPages: [
                initialPage: [
                    makeUserProfile(id: 1, login: "charlie"),
                    makeUserProfile(id: 2, login: "bravo")
                ]
            ]
        )

        let useCase = GithubSearchAutocompleteUseCaseImpl(service: service)

        let batch = try await useCase.search(query: "git", page: initialPage)

        #expect(batch.suggestions.map(\.title) == ["AlphaKit", "bravo", "charlie", "ZetaKit"])
        #expect(batch.hasMoreResults == false)
        #expect(await service.recordedRepositoryLimits() == [perEndpointResultCount])
        #expect(await service.recordedUserLimits() == [perEndpointResultCount])
        #expect(await service.recordedRepositoryPages() == [initialPage])
        #expect(await service.recordedUserPages() == [initialPage])
    }

    @Test func returnsUserResultsWhenRepositorySearchFails() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let service = SearchServiceResultStub(
            repositories: .failure(SearchServiceTestError()),
            users: .success([
                makeUserProfile(id: 1, login: "cagr")
            ])
        )
        let useCase = GithubSearchAutocompleteUseCaseImpl(service: service)

        let batch = try await useCase.search(query: "cagr", page: initialPage)

        #expect(batch.suggestions.map(\.title) == ["cagr"])
    }

    @Test func returnsRepositoryResultsWhenUserSearchFails() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let service = SearchServiceResultStub(
            repositories: .success([
                makeRepositorySummary(
                    id: 7,
                    name: "SearchKit",
                    ownerLogin: "team-search"
                )
            ]),
            users: .failure(SearchServiceTestError())
        )
        let useCase = GithubSearchAutocompleteUseCaseImpl(service: service)

        let batch = try await useCase.search(query: "search", page: initialPage)

        #expect(batch.suggestions.map(\.title) == ["SearchKit"])
        #expect(batch.suggestions.first?.kind == .repository)
    }

    @Test func throwsWhenBothEndpointSearchesFail() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let service = SearchServiceResultStub(
            repositories: .failure(SearchServiceTestError()),
            users: .failure(SearchServiceTestError())
        )
        let useCase = GithubSearchAutocompleteUseCaseImpl(service: service)

        do {
            _ = try await useCase.search(query: "fail", page: initialPage)
            Issue.record("Expected search to throw when both endpoints fail.")
        } catch {
            #expect(error is SearchServiceTestError)
        }
    }

    @Test func returnsEmptyBatchWhenBothEndpointsHaveNoMatches() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let service = SearchServiceSpy(
            repositoryPages: [initialPage: []],
            userPages: [initialPage: []]
        )
        let useCase = GithubSearchAutocompleteUseCaseImpl(service: service)

        let batch = try await useCase.search(query: "nomatches", page: initialPage)

        #expect(batch.suggestions.isEmpty)
        #expect(batch.hasMoreResults == false)
    }

    @Test func reportsWhenAnotherRemotePageIsAvailable() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let perEndpointResultCount = GithubSearchAutocompleteConfiguration.Search.perEndpointResultCount
        let repositories = (0 ..< perEndpointResultCount).map { index in
            makeRepositorySummary(
                id: index,
                name: String(format: "Repository%02d", index),
                ownerLogin: "team-\(index)",
                starCount: index
            )
        }
        let users = (0 ..< 30).map { index in
            makeUserProfile(
                id: index,
                login: String(format: "user%02d", index)
            )
        }
        let service = SearchServiceSpy(
            repositoryPages: [initialPage: repositories],
            userPages: [initialPage: users]
        )
        let useCase = GithubSearchAutocompleteUseCaseImpl(service: service)

        let batch = try await useCase.search(query: "test", page: initialPage)

        #expect(batch.suggestions.count == perEndpointResultCount + 30)
        #expect(batch.hasMoreResults == true)
        #expect(await service.recordedRepositoryLimits() == [perEndpointResultCount])
        #expect(await service.recordedUserLimits() == [perEndpointResultCount])
    }

    @Test func mapsSuggestionsWithStableTypePrefixedIDs() {
        let repository = GithubSearchSuggestion.repository(
            makeRepositorySummary(
                id: 42,
                name: "AlphaKit",
                ownerLogin: "example"
            )
        )
        let user = GithubSearchSuggestion.user(
            makeUserProfile(
                id: 42,
                login: "alpha"
            )
        )

        #expect(repository.id == "repository-42")
        #expect(repository.title == "AlphaKit")
        #expect(repository.subtitle == "example")
        #expect(repository.kind == .repository)
        #expect(user.id == "user-42")
        #expect(user.title == "alpha")
        #expect(user.kind == .user)
    }
}
