import Foundation

struct GithubSearchAutocompletePagingSession {
    private(set) var bufferedSuggestions = [GithubSearchSuggestion]()
    private(set) var currentPage = GithubSearchAutocompleteConfiguration.Search.initialPageIndex
    private(set) var hasMoreRemoteResults = false

    var hasBufferedSuggestions: Bool {
        !bufferedSuggestions.isEmpty
    }

    var hasMoreResults: Bool {
        hasBufferedSuggestions || hasMoreRemoteResults
    }

    var nextPage: Int {
        currentPage + GithubSearchAutocompleteConfiguration.Search.nextPageIncrement
    }

    mutating func applyInitialBatch(
        _ batch: GithubSearchAutocompleteBatch,
        displayPageSize: Int
    ) -> [GithubSearchSuggestion] {
        currentPage = GithubSearchAutocompleteConfiguration.Search.initialPage
        hasMoreRemoteResults = batch.hasMoreResults
        bufferedSuggestions = Array(batch.suggestions.dropFirst(displayPageSize))
        return Array(batch.suggestions.prefix(displayPageSize))
    }

    mutating func enqueueRemoteBatch(
        _ batch: GithubSearchAutocompleteBatch,
        page: Int
    ) {
        currentPage = page
        hasMoreRemoteResults = batch.hasMoreResults
        bufferedSuggestions = batch.suggestions
    }

    mutating func reset() {
        bufferedSuggestions = []
        currentPage = GithubSearchAutocompleteConfiguration.Search.initialPageIndex
        hasMoreRemoteResults = false
    }

    mutating func takeNextSuggestions(
        displayPageSize: Int
    ) -> [GithubSearchSuggestion] {
        let nextSuggestions = Array(bufferedSuggestions.prefix(displayPageSize))
        bufferedSuggestions.removeFirst(min(displayPageSize, bufferedSuggestions.count))
        return nextSuggestions
    }
}
