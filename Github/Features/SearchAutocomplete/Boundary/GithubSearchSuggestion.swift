import Foundation
import GithubAPI

struct GithubSearchSuggestion: Equatable, Identifiable, Sendable {
    enum Kind: String, Equatable, Sendable {
        case repository
        case user
    }

    let avatarURL: URL?
    let destinationURL: URL
    let detailText: String?
    let id: String
    let kind: Kind
    let primaryLanguage: String?
    let starCount: Int?
    let subtitle: String
    let title: String

    var sortValue: String {
        title
    }
}

extension GithubSearchSuggestion {
    static func repository(
        _ repository: GithubRepositorySummary
    ) -> Self {
        Self(
            avatarURL: repository.ownerAvatarURL,
            destinationURL: repository.repositoryURL,
            detailText: repository.description,
            id: GithubSearchAutocompleteConfiguration.SuggestionIdentifierPrefix.repository.makeID(repository.id),
            kind: .repository,
            primaryLanguage: repository.primaryLanguage,
            starCount: repository.starCount,
            subtitle: repository.ownerLogin,
            title: repository.name
        )
    }

    static func user(
        _ user: GithubUserProfile
    ) -> Self {
        Self(
            avatarURL: user.avatarURL,
            destinationURL: user.profileURL,
            detailText: nil,
            id: GithubSearchAutocompleteConfiguration.SuggestionIdentifierPrefix.user.makeID(user.id),
            kind: .user,
            primaryLanguage: nil,
            starCount: nil,
            subtitle: L10n.searchAutocompleteUserSubtitle,
            title: user.login
        )
    }
}
