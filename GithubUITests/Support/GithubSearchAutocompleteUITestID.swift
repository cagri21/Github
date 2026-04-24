enum GithubSearchAutocompleteUITestID {
    static let clearButton = "searchAutocomplete.clearButton"
    static let emptyState = "searchAutocomplete.state.empty"
    static let hintState = "searchAutocomplete.state.hint"
    static let loadingState = "searchAutocomplete.state.loading"
    static let resultsCount = "searchAutocomplete.resultsCount"
    static let searchField = "searchAutocomplete.searchField"

    static func resultRow(
        _ id: String
    ) -> String {
        "searchAutocomplete.resultRow.\(id)"
    }
}
