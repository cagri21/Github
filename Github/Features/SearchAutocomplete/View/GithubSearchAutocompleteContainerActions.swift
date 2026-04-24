import Foundation

struct GithubSearchAutocompleteContainerActions {
    let onLoadNextPage: () -> Void
    let onLoadNextPageIfNeeded: (GithubSearchAutocompleteItem) -> Void
    let onQueryChange: (String) -> Void
    let onCancel: () -> Void
    let onRetry: () -> Void
    let onSelect: (GithubSearchAutocompleteItem) -> Void

    @MainActor
    init(
        viewModel: GithubSearchAutocompleteViewModel,
        onSelect: @escaping (GithubSearchAutocompleteItem) -> Void
    ) {
        self.onLoadNextPage = viewModel.retryNextPage
        self.onLoadNextPageIfNeeded = viewModel.loadNextPageIfNeeded
        self.onQueryChange = viewModel.updateQuery
        self.onCancel = viewModel.clearQuery
        self.onRetry = viewModel.retry
        self.onSelect = onSelect
    }

    init() {
        self.onLoadNextPage = {}
        self.onLoadNextPageIfNeeded = { _ in }
        self.onQueryChange = { _ in }
        self.onCancel = {}
        self.onRetry = {}
        self.onSelect = { _ in }
    }
}
