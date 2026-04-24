import Foundation

struct GithubSearchAutocompleteInputProps {
    let minimumCharacterCount: Int
    let placeholder: String
    let query: String

    init(
        query: String,
        minimumCharacterCount: Int,
        placeholder: String = L10n.searchAutocompletePlaceholder
    ) {
        self.query = query
        self.minimumCharacterCount = minimumCharacterCount
        self.placeholder = placeholder
    }

    @MainActor
    init(
        viewModel: GithubSearchAutocompleteViewModel,
        placeholder: String = L10n.searchAutocompletePlaceholder
    ) {
        self.init(
            query: viewModel.query,
            minimumCharacterCount: viewModel.minimumCharacterCount,
            placeholder: placeholder
        )
    }
}
