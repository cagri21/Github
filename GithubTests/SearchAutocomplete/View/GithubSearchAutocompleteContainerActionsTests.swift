@testable import Github
import Testing

@Suite("Search autocomplete container actions")
struct GithubSearchAutocompleteContainerActionsTests {
    @Test func defaultActionsAreSafeNoops() {
        let actions = GithubSearchAutocompleteContainerActions()
        let item = GithubSearchAutocompleteItem(
            suggestion: makeSuggestion(id: "repository-42", title: "AlphaKit")
        )

        actions.onLoadNextPage()
        actions.onLoadNextPageIfNeeded(item)
        actions.onQueryChange("swift")
        actions.onCancel()
        actions.onRetry()
        actions.onSelect(item)
    }
}
