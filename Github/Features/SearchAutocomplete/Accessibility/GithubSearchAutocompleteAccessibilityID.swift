import Foundation

enum GithubSearchAutocompleteAccessibilityID {
    static let clearButton = "searchAutocomplete.clearButton"
    static let retryButton = "searchAutocomplete.retryButton"
    static let resultsCount = "searchAutocomplete.resultsCount"
    static let resultsList = "searchAutocomplete.resultsList"
    static let searchField = "searchAutocomplete.searchField"

    static func resultRow(
        _ id: String
    ) -> String {
        "searchAutocomplete.resultRow.\(id)"
    }

    static func state(
        _ model: GithubSearchAutocompleteStatusModel
    ) -> String {
        switch model {
        case .empty:
            "searchAutocomplete.state.empty"
        case .error:
            "searchAutocomplete.state.error"
        case .hint:
            "searchAutocomplete.state.hint"
        case .loading:
            "searchAutocomplete.state.loading"
        }
    }
}
