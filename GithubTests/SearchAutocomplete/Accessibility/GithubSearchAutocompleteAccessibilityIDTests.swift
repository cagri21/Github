@testable import Github
import Testing

@Suite("Search autocomplete accessibility IDs")
struct GithubSearchAutocompleteAccessibilityIDTests {
    @Test func mapsStateModelsToStableIdentifiers() {
        #expect(GithubSearchAutocompleteAccessibilityID.state(.empty) == "searchAutocomplete.state.empty")
        #expect(GithubSearchAutocompleteAccessibilityID.state(.error) == "searchAutocomplete.state.error")
        #expect(GithubSearchAutocompleteAccessibilityID.state(.hint) == "searchAutocomplete.state.hint")
        #expect(GithubSearchAutocompleteAccessibilityID.state(.loading) == "searchAutocomplete.state.loading")
    }

    @Test func buildsStableResultRowIdentifier() {
        #expect(
            GithubSearchAutocompleteAccessibilityID.resultRow("repository-42")
                == "searchAutocomplete.resultRow.repository-42"
        )
    }
}
