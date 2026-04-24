import Foundation

public struct GithubUserProfile: Equatable, Identifiable, Sendable {
    public let id: Int
    public let login: String
    public let avatarURL: URL?
    public let profileURL: URL

    public init(
        id: Int,
        login: String,
        avatarURL: URL?,
        profileURL: URL
    ) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.profileURL = profileURL
    }
}
