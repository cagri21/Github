import SwiftUI

struct GithubSearchAutocompleteContainerView: View {
    let actions: GithubSearchAutocompleteContainerActions
    let props: GithubSearchAutocompleteContainerProps

    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        ZStack {
            GithubSearchAutocompleteBackgroundView()

            VStack(spacing: GitAppLayout.Shared.zero) {
                GitSearchBar(
                    actions: searchBarActions,
                    isFocused: $isSearchFieldFocused,
                    props: searchBarProps
                )

                content

                if props.shouldShowBottomFooter {
                    GithubSearchAutocompleteFooterView(title: props.footerTitle)
                }
            }
            .padding(.horizontal, GitAppLayout.Screen.horizontalInset)
            .padding(.top, GitAppLayout.Screen.topInset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .foregroundStyle(GitVisualTheme.primaryText)
        .preferredColorScheme(.dark)
    }
}

private extension GithubSearchAutocompleteContainerView {
    var searchBarActions: GitSearchBarActions {
        GitSearchBarActions(
            onCancel: {
                isSearchFieldFocused = false
                actions.onCancel()
            },
            onQueryChange: actions.onQueryChange
        )
    }

    var searchBarProps: GitSearchBarProps {
        GitSearchBarProps(
            content: .init(
                query: props.query,
                placeholder: props.placeholder,
                cancelTitle: L10n.searchAutocompleteCancel
            ),
            style: .gitPrimary
        )
    }

    @ViewBuilder
    var content: some View {
        switch props.state {
        case let .loaded(results):
            GithubSearchAutocompleteResultsView(
                hasMoreResults: props.hasMoreResults,
                isLoadingNextPage: props.isLoadingNextPage,
                items: results,
                nextPageErrorMessage: props.nextPageErrorMessage,
                onLoadNextPage: actions.onLoadNextPage,
                onLoadNextPageIfNeeded: actions.onLoadNextPageIfNeeded,
                onSelect: actions.onSelect
            )
        case .loading:
            GithubSearchAutocompleteLoadingView()
        case let .empty(message):
            GithubSearchAutocompleteEmptyView(message: message)
        case let .error(message):
            GithubSearchAutocompleteErrorView(
                message: message,
                onRetry: actions.onRetry
            )
        case let .hint(message):
            GithubSearchAutocompleteHintView(
                minimumCharacterCount: props.minimumCharacterCount,
                message: message
            )
        }
    }
}
