import SwiftUI

struct GithubSearchAutocompleteViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            preview(
                name: GithubSearchAutocompleteConfiguration.Preview.FrameName.results.rawValue,
                query: GithubSearchAutocompleteConfiguration.Preview.resultsQuery,
                state: .loaded(results: GithubSearchAutocompletePreviewData.sampleItems)
            )

            preview(
                name: GithubSearchAutocompleteConfiguration.Preview.FrameName.loading.rawValue,
                query: GithubSearchAutocompleteConfiguration.Preview.resultsQuery,
                state: .loading
            )

            preview(
                name: GithubSearchAutocompleteConfiguration.Preview.FrameName.empty.rawValue,
                query: GithubSearchAutocompleteConfiguration.Preview.emptyQuery,
                state: .empty(
                    message: L10n.searchAutocompleteNoResultsFor(
                        GithubSearchAutocompleteConfiguration.Preview.emptyQuery
                    )
                )
            )

            preview(
                name: GithubSearchAutocompleteConfiguration.Preview.FrameName.error.rawValue,
                query: GithubSearchAutocompleteConfiguration.Preview.resultsQuery,
                state: .error(message: L10n.searchAutocompleteErrorMessage)
            )

            preview(
                name: GithubSearchAutocompleteConfiguration.Preview.FrameName.hint.rawValue,
                query: GithubSearchAutocompleteConfiguration.Preview.hintQuery,
                state: .hint(
                    message: L10n.searchAutocompleteKeepTyping(
                        GithubSearchAutocompleteConfiguration.Search.minimumQueryLength
                    )
                )
            )
        }
    }

    private static func preview(
        name: String,
        query: String,
        state: GithubSearchAutocompleteState
    ) -> some View {
        GithubSearchAutocompleteContainerView(
            actions: .init(),
            props: .init(
                input: .init(
                    query: query,
                    minimumCharacterCount: GithubSearchAutocompleteConfiguration.Preview.minimumCharacterCount
                ),
                state: state
            )
        )
        .previewDisplayName(name)
        .previewDevice(
            GithubSearchAutocompleteConfiguration.Preview.Device.iPhone15Pro.previewDevice
        )
    }
}
