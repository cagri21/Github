import Foundation

struct GithubSearchAutocompleteViewModelPolicy {
    let displayPageSize: Int
    let minimumQueryLength: Int
    let searchDelay: Duration

    init(
        displayPageSize: Int = GithubSearchAutocompleteConfiguration.Search.displayPageSize,
        minimumQueryLength: Int = GithubSearchAutocompleteConfiguration.Search.minimumQueryLength,
        searchDelay: Duration = GithubSearchAutocompleteConfiguration.Search.searchDelay
    ) {
        self.displayPageSize = displayPageSize
        self.minimumQueryLength = minimumQueryLength
        self.searchDelay = searchDelay
    }
}

struct GithubSearchAutocompleteViewModelRuntime {
    typealias Sleep = @Sendable (Duration) async throws -> Void
    typealias SuggestionItemBuilder = @Sendable (GithubSearchSuggestion) -> GithubSearchAutocompleteItem

    let sleep: Sleep
    let suggestionItemBuilder: SuggestionItemBuilder

    init(
        sleep: @escaping Sleep = { duration in
            try await ContinuousClock().sleep(for: duration)
        },
        suggestionItemBuilder: @escaping SuggestionItemBuilder = { @Sendable suggestion in
            GithubSearchAutocompleteItem(suggestion: suggestion)
        }
    ) {
        self.sleep = sleep
        self.suggestionItemBuilder = suggestionItemBuilder
    }
}
