@testable import Github
import Testing

@Suite("Search autocomplete status model")
struct GithubSearchAutocompleteStatusModelTests {
    @Test func mapsModelsToExpectedSymbols() {
        #expect(GithubSearchAutocompleteStatusModel.empty.symbol == .magnifyingglass)
        #expect(GithubSearchAutocompleteStatusModel.error.symbol == .errorOctagon)
        #expect(GithubSearchAutocompleteStatusModel.hint.symbol == .magnifyingglass)
        #expect(GithubSearchAutocompleteStatusModel.loading.symbol == .sparkle)
    }

    @Test func mapsModelsToExpectedGlyphKinds() {
        #expect(GithubSearchAutocompleteStatusModel.empty.glyphKind == .symbol(.magnifyingglass))
        #expect(GithubSearchAutocompleteStatusModel.error.glyphKind == .symbol(.errorOctagon))
        #expect(GithubSearchAutocompleteStatusModel.hint.glyphKind == .symbol(.magnifyingglass))
        #expect(GithubSearchAutocompleteStatusModel.loading.glyphKind == .loading(.sparkle))
    }

    @Test func resolvesColorForEveryModel() {
        let models = [
            GithubSearchAutocompleteStatusModel.empty,
            .error,
            .hint,
            .loading
        ]

        for model in models {
            _ = model.color
        }
    }
}
