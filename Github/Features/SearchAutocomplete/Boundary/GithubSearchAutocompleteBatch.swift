import Foundation

struct GithubSearchAutocompleteBatch: Equatable, Sendable {
    let suggestions: [GithubSearchSuggestion]
    let hasMoreResults: Bool
}
