import Foundation
@testable import Github
import GithubAPI
import Testing

struct GithubSearchAutocompleteUseCaseTests {
    @Test func requestsFiftyFromEachEndpointAndSortsMergedResults() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let perEndpointResultCount = GithubSearchAutocompleteConfiguration.Search.perEndpointResultCount
        let service = SearchServiceSpy(
            repositoryPages: [
                initialPage: [
                    GithubRepositorySummary(
                        id: 1,
                        name: "ZetaKit",
                        ownerLogin: "team-z",
                        description: nil,
                        primaryLanguage: "Swift",
                        repositoryURL: URL(string: "https://github.com/example/ZetaKit")!,
                        ownerAvatarURL: nil,
                        starCount: 4_200
                    ),
                    GithubRepositorySummary(
                        id: 2,
                        name: "AlphaKit",
                        ownerLogin: "team-a",
                        description: nil,
                        primaryLanguage: "Swift",
                        repositoryURL: URL(string: "https://github.com/example/AlphaKit")!,
                        ownerAvatarURL: nil,
                        starCount: 1_100
                    )
                ]
            ],
            userPages: [
                initialPage: [
                    GithubUserProfile(
                        id: 1,
                        login: "charlie",
                        avatarURL: nil,
                        profileURL: URL(string: "https://github.com/charlie")!
                    ),
                    GithubUserProfile(
                        id: 2,
                        login: "bravo",
                        avatarURL: nil,
                        profileURL: URL(string: "https://github.com/bravo")!
                    )
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
                GithubUserProfile(
                    id: 1,
                    login: "cagr",
                    avatarURL: nil,
                    profileURL: URL(string: "https://github.com/cagr")!
                )
            ])
        )
        let useCase = GithubSearchAutocompleteUseCaseImpl(service: service)

        let batch = try await useCase.search(query: "cagr", page: initialPage)

        #expect(batch.suggestions.map(\.title) == ["cagr"])
    }

    @Test func reportsWhenAnotherRemotePageIsAvailable() async throws {
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let perEndpointResultCount = GithubSearchAutocompleteConfiguration.Search.perEndpointResultCount
        let repositories = (0 ..< perEndpointResultCount).map { index in
            GithubRepositorySummary(
                id: index,
                name: String(format: "Repository%02d", index),
                ownerLogin: "team-\(index)",
                description: nil,
                primaryLanguage: "Swift",
                repositoryURL: URL(string: "https://github.com/example/repository-\(index)")!,
                ownerAvatarURL: nil,
                starCount: index
            )
        }
        let users = (0 ..< 30).map { index in
            GithubUserProfile(
                id: index,
                login: String(format: "user%02d", index),
                avatarURL: nil,
                profileURL: URL(string: "https://github.com/user\(index)")!
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
}

@MainActor
struct GithubSearchAutocompleteViewModelTests {
    @Test func requiresMinimumCharactersBeforeSearching() async throws {
        let minimumQueryLength = GithubSearchAutocompleteConfiguration.Search.minimumQueryLength
        let spy = SearchUseCaseSpy()
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: spy,
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("ab")

        if case let .hint(message) = viewModel.state {
            #expect(message.contains("\(minimumQueryLength)"))
        } else {
            Issue.record("Expected hint state for short queries.")
        }

        let queries = await spy.recordedQueries()
        #expect(queries.isEmpty)
    }

    @Test func keepsOnlyLatestResultsDuringRapidInputChanges() async throws {
        let useCase = SearchUseCaseStub { query, _ in
            if query == "swift" {
                try await Task.sleep(for: .milliseconds(80))
                return GithubSearchAutocompleteBatch(
                    suggestions: [
                        GithubSearchSuggestion(
                            avatarURL: nil,
                            destinationURL: URL(string: "https://github.com/apple/swift")!,
                            detailText: nil,
                            id: "repository-swift",
                            kind: .repository,
                            primaryLanguage: "Swift",
                            starCount: 68_000,
                            subtitle: "apple",
                            title: "Swift"
                        )
                    ],
                    hasMoreResults: false
                )
            }

            return GithubSearchAutocompleteBatch(
                suggestions: [
                    GithubSearchSuggestion(
                        avatarURL: nil,
                        destinationURL: URL(string: "https://github.com/apple/swiftui")!,
                        detailText: nil,
                        id: "repository-swiftui",
                        kind: .repository,
                        primaryLanguage: "Swift",
                        starCount: 45_000,
                        subtitle: "apple",
                        title: "SwiftUI"
                    )
                ],
                hasMoreResults: false
            )
        }

        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: useCase,
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("swift")
        viewModel.updateQuery("swiftui")

        try await Task.sleep(for: .milliseconds(140))

        if case let .loaded(results: items) = viewModel.state {
            #expect(items.map(\.title) == ["SwiftUI"])
        } else {
            Issue.record("Expected only the latest result set to remain visible.")
        }
    }

    @Test func loadsNextPageWhenLastVisibleItemAppears() async throws {
        let displayPageSize = GithubSearchAutocompleteConfiguration.Search.displayPageSize
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let nextPage = initialPage + GithubSearchAutocompleteConfiguration.Search.nextPageIncrement
        let firstPageSuggestions = (0 ..< displayPageSize).map { index in
            GithubSearchSuggestion(
                avatarURL: nil,
                destinationURL: URL(string: "https://github.com/example/repository-\(index)")!,
                detailText: nil,
                id: "repository-\(index)",
                kind: .repository,
                primaryLanguage: "Swift",
                starCount: index,
                subtitle: "example",
                title: String(format: "Repository%02d", index)
            )
        }
        let secondPageSuggestion = GithubSearchSuggestion(
            avatarURL: nil,
            destinationURL: URL(string: "https://github.com/example/repository-50")!,
            detailText: nil,
            id: "repository-50",
            kind: .repository,
            primaryLanguage: "Swift",
            starCount: 50,
            subtitle: "example",
            title: "Repository50"
        )
        let useCase = SearchUseCaseStub { _, page in
            switch page {
            case initialPage:
                GithubSearchAutocompleteBatch(
                    suggestions: firstPageSuggestions,
                    hasMoreResults: true
                )
            case nextPage:
                GithubSearchAutocompleteBatch(
                    suggestions: [secondPageSuggestion],
                    hasMoreResults: false
                )
            default:
                GithubSearchAutocompleteBatch(
                    suggestions: [],
                    hasMoreResults: false
                )
            }
        }

        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: useCase,
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("repos")
        try await Task.sleep(for: .milliseconds(20))

        guard case let .loaded(results: initialItems) = viewModel.state,
              let lastItem = initialItems.last
        else {
            Issue.record("Expected initial paginated results.")
            return
        }

        #expect(initialItems.count == displayPageSize)
        #expect(viewModel.hasMoreResults == true)

        viewModel.loadNextPageIfNeeded(currentItem: lastItem)
        try await Task.sleep(for: .milliseconds(20))

        if case let .loaded(results: appendedItems) = viewModel.state {
            #expect(appendedItems.count == 51)
            #expect(appendedItems.last?.id == "repository-50")
            #expect(viewModel.hasMoreResults == false)
        } else {
            Issue.record("Expected appended paginated results.")
        }
    }
}

private actor SearchServiceSpy: SearchService {
    let repositoryPages: [Int: [GithubRepositorySummary]]
    let userPages: [Int: [GithubUserProfile]]
    private var repositoryLimits = [Int]()
    private var repositoryPagesRequested = [Int]()
    private var userLimits = [Int]()
    private var userPagesRequested = [Int]()

    init(
        repositoryPages: [Int: [GithubRepositorySummary]],
        userPages: [Int: [GithubUserProfile]]
    ) {
        self.repositoryPages = repositoryPages
        self.userPages = userPages
    }

    func searchRepositories(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubRepositorySummary] {
        repositoryLimits.append(limit)
        repositoryPagesRequested.append(page)
        return Array((repositoryPages[page] ?? []).prefix(limit))
    }

    func searchUsers(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubUserProfile] {
        userLimits.append(limit)
        userPagesRequested.append(page)
        return Array((userPages[page] ?? []).prefix(limit))
    }

    func recordedRepositoryLimits() -> [Int] {
        repositoryLimits
    }

    func recordedRepositoryPages() -> [Int] {
        repositoryPagesRequested
    }

    func recordedUserLimits() -> [Int] {
        userLimits
    }

    func recordedUserPages() -> [Int] {
        userPagesRequested
    }
}

private actor SearchUseCaseSpy: GithubSearchAutocompleteUseCase {
    private var queries = [String]()

    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch {
        queries.append(query)
        return GithubSearchAutocompleteBatch(
            suggestions: [],
            hasMoreResults: false
        )
    }

    func recordedQueries() -> [String] {
        queries
    }
}

private struct SearchUseCaseStub: GithubSearchAutocompleteUseCase {
    let handler: @Sendable (String, Int) async throws -> GithubSearchAutocompleteBatch

    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch {
        try await handler(query, page)
    }
}

private struct SearchServiceResultStub: SearchService {
    let repositories: Result<[GithubRepositorySummary], Error>
    let users: Result<[GithubUserProfile], Error>

    func searchRepositories(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubRepositorySummary] {
        try repositories.get()
    }

    func searchUsers(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubUserProfile] {
        try users.get()
    }
}

private struct SearchServiceTestError: Error {}
