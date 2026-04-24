import Foundation
@testable import Github
import Testing

@MainActor
@Suite("Search autocomplete view model")
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

    @Test func trimsWhitespaceBeforeSearching() async throws {
        let spy = SearchUseCaseSpy()
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: spy,
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("  swift  ")
        try await waitForViewModelTasks()

        #expect(await spy.recordedQueries() == ["swift"])
    }

    @Test func showsEmptyStateForEmptySearchBatch() async throws {
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: SearchUseCaseStub { _, _ in
                GithubSearchAutocompleteBatch(
                    suggestions: [],
                    hasMoreResults: false
                )
            },
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("empty")
        try await waitForViewModelTasks()

        if case let .empty(message) = viewModel.state {
            #expect(message.contains("empty"))
        } else {
            Issue.record("Expected empty state for an empty search batch.")
        }
    }

    @Test func showsErrorStateForInitialSearchFailure() async throws {
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: SearchUseCaseStub { _, _ in
                throw SearchServiceTestError()
            },
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("error")
        try await waitForViewModelTasks()

        if case let .error(message) = viewModel.state {
            #expect(message == L10n.searchAutocompleteErrorMessage)
        } else {
            Issue.record("Expected error state for an initial search failure.")
        }
    }

    @Test func retryUsesTheLatestQuery() async throws {
        let spy = SearchUseCaseSpy()
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: spy,
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("swift")
        try await waitForViewModelTasks()
        viewModel.retry()
        try await waitForViewModelTasks()

        #expect(await spy.recordedQueries() == ["swift", "swift"])
        #expect(await spy.recordedPages() == [1, 1])
    }

    @Test func clearQueryResetsToInitialHint() async throws {
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: SearchUseCaseStub { _, _ in
                GithubSearchAutocompleteBatch(
                    suggestions: [makeSuggestion(id: "repository-swift", title: "Swift")],
                    hasMoreResults: false
                )
            },
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("swift")
        try await waitForViewModelTasks()
        viewModel.clearQuery()

        #expect(viewModel.query.isEmpty)
        if case let .hint(message) = viewModel.state {
            #expect(message.contains("\(viewModel.minimumCharacterCount)"))
        } else {
            Issue.record("Expected initial hint after clearing the query.")
        }
    }

    @Test func keepsOnlyLatestResultsDuringRapidInputChanges() async throws {
        let useCase = SearchUseCaseStub { query, _ in
            if query == "swift" {
                try await Task.sleep(for: .milliseconds(80))
                return GithubSearchAutocompleteBatch(
                    suggestions: [
                        makeSuggestion(
                            id: "repository-swift",
                            title: "Swift",
                            subtitle: "apple"
                        )
                    ],
                    hasMoreResults: false
                )
            }

            return GithubSearchAutocompleteBatch(
                suggestions: [
                    makeSuggestion(
                        id: "repository-swiftui",
                        title: "SwiftUI",
                        subtitle: "apple"
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

    @Test func appendsBufferedSuggestionsBeforeRequestingAnotherRemotePage() async throws {
        let displayPageSize = GithubSearchAutocompleteConfiguration.Search.displayPageSize
        let suggestions = (0 ..< displayPageSize + 10).map { index in
            makeSuggestion(
                id: "repository-\(index)",
                title: String(format: "Repository%02d", index)
            )
        }
        let recorder = SearchUseCaseRecordingStub { _, _ in
            GithubSearchAutocompleteBatch(
                suggestions: suggestions,
                hasMoreResults: false
            )
        }
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: recorder,
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("repos")
        try await waitForViewModelTasks()

        guard case let .loaded(results: initialItems) = viewModel.state,
              let lastVisibleItem = initialItems.last
        else {
            Issue.record("Expected first visible page.")
            return
        }

        #expect(initialItems.count == displayPageSize)

        viewModel.loadNextPageIfNeeded(currentItem: lastVisibleItem)
        try await waitForViewModelTasks()

        if case let .loaded(results: appendedItems) = viewModel.state {
            #expect(appendedItems.count == displayPageSize + 10)
        } else {
            Issue.record("Expected buffered suggestions to append.")
        }

        let requests = await recorder.recordedRequests()
        let requestedPages = requests.map(\.page)
        #expect(requestedPages == [1])
    }

    @Test func doesNotLoadNextPageWhenNonLastItemAppears() async throws {
        let displayPageSize = GithubSearchAutocompleteConfiguration.Search.displayPageSize
        let suggestions = (0 ..< displayPageSize).map { index in
            makeSuggestion(
                id: "repository-\(index)",
                title: String(format: "Repository%02d", index)
            )
        }
        let recorder = SearchUseCaseRecordingStub { _, page in
            GithubSearchAutocompleteBatch(
                suggestions: page == 1 ? suggestions : [makeSuggestion(id: "repository-next", title: "Next")],
                hasMoreResults: page == 1
            )
        }
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: recorder,
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("repos")
        try await waitForViewModelTasks()

        guard case let .loaded(results: initialItems) = viewModel.state,
              let firstItem = initialItems.first
        else {
            Issue.record("Expected initial results.")
            return
        }

        viewModel.loadNextPageIfNeeded(currentItem: firstItem)
        try await waitForViewModelTasks()

        let requests = await recorder.recordedRequests()
        let requestedPages = requests.map(\.page)
        #expect(requestedPages == [1])
    }

    @Test func loadsNextPageWhenLastVisibleItemAppears() async throws {
        let displayPageSize = GithubSearchAutocompleteConfiguration.Search.displayPageSize
        let initialPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        let nextPage = initialPage + GithubSearchAutocompleteConfiguration.Search.nextPageIncrement
        let firstPageSuggestions = (0 ..< displayPageSize).map { index in
            makeSuggestion(
                id: "repository-\(index)",
                title: String(format: "Repository%02d", index),
                subtitle: "example"
            )
        }
        let secondPageSuggestion = makeSuggestion(
            id: "repository-50",
            title: "Repository50",
            subtitle: "example"
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

    @Test func nextPageFailureKeepsCurrentResultsAndShowsRetryMessage() async throws {
        let displayPageSize = GithubSearchAutocompleteConfiguration.Search.displayPageSize
        let initialSuggestions = (0 ..< displayPageSize).map { index in
            makeSuggestion(
                id: "repository-\(index)",
                title: String(format: "Repository%02d", index)
            )
        }
        let viewModel = GithubSearchAutocompleteViewModel(
            useCase: SearchUseCaseStub { _, page in
                if page == 1 {
                    return GithubSearchAutocompleteBatch(
                        suggestions: initialSuggestions,
                        hasMoreResults: true
                    )
                }

                throw SearchServiceTestError()
            },
            policy: .init(searchDelay: .zero),
            runtime: .init(sleep: { _ in })
        )

        viewModel.updateQuery("repos")
        try await waitForViewModelTasks()

        guard case let .loaded(results: initialItems) = viewModel.state,
              let lastItem = initialItems.last
        else {
            Issue.record("Expected initial results.")
            return
        }

        viewModel.loadNextPageIfNeeded(currentItem: lastItem)
        try await waitForViewModelTasks()

        if case let .loaded(results: currentItems) = viewModel.state {
            #expect(currentItems == initialItems)
        } else {
            Issue.record("Expected existing results to remain visible.")
        }
        #expect(viewModel.isLoadingNextPage == false)
        #expect(viewModel.nextPageErrorMessage == L10n.searchAutocompleteErrorMessage)
        #expect(viewModel.hasMoreResults == true)
    }
}
