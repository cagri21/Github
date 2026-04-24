import Foundation
@testable import Github
import GithubAPI

func makeRepositorySummary(
    id: Int,
    name: String,
    ownerLogin: String,
    description: String? = nil,
    primaryLanguage: String? = "Swift",
    starCount: Int = 100
) -> GithubRepositorySummary {
    GithubRepositorySummary(
        id: id,
        name: name,
        ownerLogin: ownerLogin,
        description: description,
        primaryLanguage: primaryLanguage,
        repositoryURL: URL(string: "https://github.com/\(ownerLogin)/\(name)")!,
        ownerAvatarURL: nil,
        starCount: starCount
    )
}

func makeSuggestion(
    id: String,
    title: String,
    kind: GithubSearchSuggestion.Kind = .repository,
    subtitle: String = "example"
) -> GithubSearchSuggestion {
    GithubSearchSuggestion(
        avatarURL: nil,
        destinationURL: URL(string: "https://github.com/example/\(title)")!,
        detailText: nil,
        id: id,
        kind: kind,
        primaryLanguage: kind == .repository ? "Swift" : nil,
        starCount: kind == .repository ? 100 : nil,
        subtitle: subtitle,
        title: title
    )
}

func makeUserProfile(
    id: Int,
    login: String
) -> GithubUserProfile {
    GithubUserProfile(
        id: id,
        login: login,
        avatarURL: nil,
        profileURL: URL(string: "https://github.com/\(login)")!
    )
}
