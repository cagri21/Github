import Foundation

struct GithubSearchAutocompleteContainerProps {
    let input: GithubSearchAutocompleteInputProps
    let pagination: GithubSearchAutocompletePaginationProps
    let state: GithubSearchAutocompleteState

    init(
        input: GithubSearchAutocompleteInputProps,
        state: GithubSearchAutocompleteState,
        pagination: GithubSearchAutocompletePaginationProps = .init()
    ) {
        self.input = input
        self.state = state
        self.pagination = pagination
    }

    @MainActor
    init(
        viewModel: GithubSearchAutocompleteViewModel,
        placeholder: String = L10n.searchAutocompletePlaceholder
    ) {
        self.init(
            input: .init(viewModel: viewModel, placeholder: placeholder),
            state: viewModel.state,
            pagination: .init(viewModel: viewModel)
        )
    }
}

extension GithubSearchAutocompleteContainerProps {
    var hasMoreResults: Bool {
        pagination.hasMoreResults
    }

    var footerTitle: String {
        switch state {
        case .loading:
            L10n.searchAutocompleteFooterLoading
        case .empty:
            L10n.searchAutocompleteFooterEmpty
        case .error:
            L10n.searchAutocompleteFooterError
        case .hint:
            L10n.searchAutocompleteFooterHint
        case .loaded:
            L10n.searchAutocompleteFooterResults
        }
    }

    var shouldShowBottomFooter: Bool {
        state.results == nil
    }

    var isLoadingNextPage: Bool {
        pagination.isLoadingNextPage
    }

    var minimumCharacterCount: Int {
        input.minimumCharacterCount
    }

    var nextPageErrorMessage: String? {
        pagination.nextPageErrorMessage
    }

    var placeholder: String {
        input.placeholder
    }

    var query: String {
        input.query
    }
}
