import Foundation

struct GithubSearchAutocompletePaginationProps {
    let hasMoreResults: Bool
    let isLoadingNextPage: Bool
    let nextPageErrorMessage: String?

    init(
        hasMoreResults: Bool = false,
        isLoadingNextPage: Bool = false,
        nextPageErrorMessage: String? = nil
    ) {
        self.hasMoreResults = hasMoreResults
        self.isLoadingNextPage = isLoadingNextPage
        self.nextPageErrorMessage = nextPageErrorMessage
    }

    @MainActor
    init(
        viewModel: GithubSearchAutocompleteViewModel
    ) {
        self.init(
            hasMoreResults: viewModel.hasMoreResults,
            isLoadingNextPage: viewModel.isLoadingNextPage,
            nextPageErrorMessage: viewModel.nextPageErrorMessage
        )
    }
}
