import Foundation

struct GithubSearchAutocompleteItem: Equatable, Identifiable, Sendable {
    let avatarURL: URL?
    let destinationURL: URL
    let detailText: String?
    let id: String
    let kind: GithubSearchSuggestion.Kind
    let primaryLanguage: String?
    let starCount: Int?
    let subtitle: String
    let title: String
}

extension GithubSearchAutocompleteItem {
    init(
        suggestion: GithubSearchSuggestion
    ) {
        self.init(
            avatarURL: suggestion.avatarURL,
            destinationURL: suggestion.destinationURL,
            detailText: suggestion.detailText,
            id: suggestion.id,
            kind: suggestion.kind,
            primaryLanguage: suggestion.primaryLanguage,
            starCount: suggestion.starCount,
            subtitle: suggestion.subtitle,
            title: suggestion.title
        )
    }
}
