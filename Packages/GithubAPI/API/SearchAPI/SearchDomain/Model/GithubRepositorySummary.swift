import Foundation

public struct GithubRepositorySummary: Equatable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let ownerLogin: String
    public let description: String?
    public let primaryLanguage: String?
    public let repositoryURL: URL
    public let ownerAvatarURL: URL?
    public let starCount: Int

    public init(
        id: Int,
        name: String,
        ownerLogin: String,
        description: String?,
        primaryLanguage: String?,
        repositoryURL: URL,
        ownerAvatarURL: URL?,
        starCount: Int
    ) {
        self.id = id
        self.name = name
        self.ownerLogin = ownerLogin
        self.description = description
        self.primaryLanguage = primaryLanguage
        self.repositoryURL = repositoryURL
        self.ownerAvatarURL = ownerAvatarURL
        self.starCount = starCount
    }
}
