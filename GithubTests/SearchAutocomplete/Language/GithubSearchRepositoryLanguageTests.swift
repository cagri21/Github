@testable import Github
import Testing

@Suite("Search repository language")
struct GithubSearchRepositoryLanguageTests {
    @Test func normalizesKnownLanguageNames() {
        #expect(GithubSearchRepositoryLanguage(displayName: "Go") == .golang)
        #expect(GithubSearchRepositoryLanguage(displayName: "Kotlin") == .kotlin)
        #expect(GithubSearchRepositoryLanguage(displayName: "Python") == .python)
        #expect(GithubSearchRepositoryLanguage(displayName: "Ruby") == .ruby)
        #expect(GithubSearchRepositoryLanguage(displayName: "Swift") == .swift)
        #expect(GithubSearchRepositoryLanguage(displayName: " javascript ") == .javaScript)
        #expect(GithubSearchRepositoryLanguage(displayName: "TypeScript") == .typeScript)
    }

    @Test func returnsNilForUnknownLanguageNames() {
        #expect(GithubSearchRepositoryLanguage(displayName: "Elixir") == nil)
    }

    @Test func resolvesDotColorForSupportedAndUnsupportedLanguages() {
        [
            "Go",
            "JavaScript",
            "Kotlin",
            "Python",
            "Ruby",
            "Swift",
            "TypeScript",
            "Elixir"
        ].forEach { displayName in
            _ = GithubSearchRepositoryLanguage.dotColor(for: displayName)
        }
    }
}
