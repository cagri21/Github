@testable import Github
import Testing

struct GithubSearchRepositoryLanguageTests {
    @Test func normalizesKnownLanguageNames() {
        #expect(GithubSearchRepositoryLanguage(displayName: "Swift") == .swift)
        #expect(GithubSearchRepositoryLanguage(displayName: " javascript ") == .javaScript)
        #expect(GithubSearchRepositoryLanguage(displayName: "TypeScript") == .typeScript)
    }

    @Test func returnsNilForUnknownLanguageNames() {
        #expect(GithubSearchRepositoryLanguage(displayName: "Elixir") == nil)
    }
}
