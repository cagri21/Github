#if DEBUG
import Foundation

enum GithubSearchAutocompleteUITesting {
    static let launchArgument = "-github-search-ui-testing"

    static var isEnabled: Bool {
        ProcessInfo.processInfo.arguments.contains(launchArgument)
    }
}

struct GithubSearchAutocompleteUITestUseCase: GithubSearchAutocompleteUseCase {
    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch {
        switch query.lowercased() {
        case "empty":
            return GithubSearchAutocompleteBatch(
                suggestions: [],
                hasMoreResults: false
            )
        case "error":
            throw GithubSearchAutocompleteUITestError()
        case "loading":
            try await Task.sleep(for: .seconds(2))
            return GithubSearchAutocompleteBatch(
                suggestions: [Self.repositorySuggestion],
                hasMoreResults: false
            )
        default:
            return GithubSearchAutocompleteBatch(
                suggestions: Self.defaultSuggestions,
                hasMoreResults: false
            )
        }
    }
}

private extension GithubSearchAutocompleteUITestUseCase {
    static let repositorySuggestion = GithubSearchSuggestion(
        avatarURL: nil,
        destinationURL: URL(string: "https://github.com/example/AlphaKit")!,
        detailText: "A deterministic repository fixture for UI tests.",
        id: "repository-100",
        kind: .repository,
        primaryLanguage: "Swift",
        starCount: 1_250,
        subtitle: "example",
        title: "AlphaKit"
    )

    static let defaultSuggestions = [
        repositorySuggestion,
        GithubSearchSuggestion(
            avatarURL: nil,
            destinationURL: URL(string: "https://github.com/bravo")!,
            detailText: nil,
            id: "user-200",
            kind: .user,
            primaryLanguage: nil,
            starCount: nil,
            subtitle: L10n.searchAutocompleteUserSubtitle,
            title: "bravo"
        ),
        GithubSearchSuggestion(
            avatarURL: nil,
            destinationURL: URL(string: "https://github.com/example/ZetaKit")!,
            detailText: "Another deterministic repository fixture for UI tests.",
            id: "repository-101",
            kind: .repository,
            primaryLanguage: "Swift",
            starCount: 4_200,
            subtitle: "example",
            title: "ZetaKit"
        )
    ]
}

private struct GithubSearchAutocompleteUITestError: Error {}
#endif
